class GemLoader

  def initialize(client: Gems::Client.new)
    @client = client
  end

  def get_spec_from_api(gem_name)
    @client.info(gem_name)
  end

  def get_owners_from_api(gem_name)
    @client.owners(gem_name)
  end

  def get_build_start_from_api(gem_name)
    @client.versions(gem_name)
  end

  def fetch_and_create_gem_spec(laser_gem)
    gem_data = get_spec_from_api(laser_gem.name)
    first_version = get_build_start_from_api(laser_gem.name)
    attribs = {}
    spec_attributes.each  do |k,v| 
      attribs[k] = gem_data[v] 
    end
    GemSpec.find_or_create_by!(attribs.merge laser_gem_id: laser_gem.id, build_date: first_version[-1]["built_at"])
    fetch_and_spec_deps(laser_gem, gem_data["dependencies"]["runtime"])
    fetch_owners(laser_gem)
  end

  # Not yet creating a user/owner
  def fetch_owners(laser_gem)
    return unless laser_gem.ownerships.where(["rubygem_owner = ?", true]).count == 0
    owner_array = get_owners_from_api(laser_gem.name)
    owner_array.each do |owner|
      gem_handle = owner["handle"]
      email = owner["email"]
      ownership = Ownership.find_or_create_by!(laser_gem_id: laser_gem.id, email: email)
      ownership.update(rubygem_owner: true, gem_handle: gem_handle)
    end
    # fetch_owners_for_deps(laser_gem)
    laser_gem.dependencies.each { |dep| fetch_owners(dep) }
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
      authors: "authors",
    }
  end
end
