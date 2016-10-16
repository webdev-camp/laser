class GemLoader

  def initialize(client: Gems::Client.new)
    @client = client
  end

  def get_spec_by_name(gem_name)
    @data = @client.info(gem_name)
  end

  def populate_data(laser_gem)
    gem_data = get_spec_by_name(laser_gem.name)
    gs = GemSpec.new
    gs.name = gem_data["name"]
    gs.info = gem_data["info"]
    gs.current_version = gem_data["version"]
    gs.current_version_downloads = gem_data["version_downloads"]
    gs.total_downloads = gem_data["downloads"]
    gs.rubygem_uri = gem_data["project_uri"]
    gs.documentation_uri = gem_data["documentation_uri"]
    gs.save!
    dep_hash = gem_data["dependencies"]
    runtime_deps = dep_hash["runtime"]

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
end
