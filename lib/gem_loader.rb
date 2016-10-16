class GemLoader

  def initialize(client: Gems::Client.new)
    @client = client
  end

  def get_spec_by_name(gem_name)
    @data = @client.info(gem_name)
  end

  def populate_data(laser_gem)
    @gem_data = get_spec_by_name(laser_gem.name)
    attribs = {}
    spec_attributes.each do |k,v|
      # try using map
      attribs[k] = @gem_data[v]
    end
    GemSpec.create!(attribs.merge laser_gem_id: laser_gem.id)
    populate_dependencies(laser_gem)
  end

  def populate_dependencies(laser_gem)
    runtime_deps = @gem_data["dependencies"]["runtime"]

    runtime_deps.each do |gem_dep|
      dep = gem_dep["name"]
      ver = gem_dep["requirements"]
      lg_dep = LaserGem.find_by(name: dep)
      if lg_dep == nil
        lg_dep = LaserGem.create!(name: dep)
        laser_gem.register_dependency(lg_dep, ver)
        populate_data(lg_dep)
      else
        laser_gem.register_dependency(lg_dep, ver)
        populate_data(lg_dep) if lg_dep.gem_spec.nil?
      end
    end
  end

  private
  def spec_attributes
    {
     name: "name",
     info: "info",
     current_version: "version",
     current_version_downloads: "version_downloads",
     total_downloads: "version_downloads",
     rubygem_uri: "project_uri",
     documentation_uri: "documentation_uri",
     source_code_uri: "source_code_uri",
     homepage_uri: "homepage_uri",
    }
  end
end
