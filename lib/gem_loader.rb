class GemLoader

  def initialize(client: Gems::Client.new)
    @client = client
  end

  def get_spec_from_api(gem_name)
    @client.info(gem_name)
  end

  def fetch_and_create_gem_spec(laser_gem)
    gem_data = get_spec_from_api(laser_gem.name)
    attribs = {}
    spec_attributes.each { |k,v| attribs[k] = gem_data[v] }
    GemSpec.find_or_create_by!(attribs.merge laser_gem_id: laser_gem.id)
    fetch_and_spec_deps(laser_gem, gem_data["dependencies"]["runtime"])
  end

  def fetch_and_spec_deps(laser_gem, runtime_deps)
    runtime_deps.each do |gem_dep|
      dep = gem_dep["name"]
      ver = gem_dep["requirements"]
      lg_dep = LaserGem.find_or_create_by!(name: dep)
      laser_gem.register_dependency(lg_dep, ver) unless GemDependency.where("laser_gem_id = ? and dependency_id = ?", laser_gem.id, lg_dep.id).exists?
      fetch_and_create_gem_spec(lg_dep) if lg_dep.gem_spec.nil?
    end
  end

  private
  def spec_attributes
    {
      name: "name",
      info: "info",
      current_version: "version",
      current_version_downloads: "version_downloads",
      total_downloads: "downloads",
      rubygem_uri: "project_uri",
      documentation_uri: "documentation_uri",
      source_code_uri: "source_code_uri",
      homepage_uri: "homepage_uri",
    }
  end
end
