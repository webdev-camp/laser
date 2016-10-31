class GemLoader

  def initialize(client: Gems::Client.new)
    @client = client
  end

  def get_spec_from_api(gem_name)
    data = @client.info(gem_name)
    return nil if data == "This rubygem could not be found."
    return data
  end

  def get_owners_from_api(gem_name)
    @client.owners(gem_name)
  end

  def get_build_start_from_api(gem_name)
    @client.versions(gem_name)[-1]
  end

  def fetch_and_create_gem_spec(laser_gem)
    gem_data = get_spec_from_api(laser_gem.name)
    return unless gem_data
    unless laser_gem.gem_spec
      first_version = get_build_start_from_api(laser_gem.name)
      attribs = {laser_gem_id: laser_gem.id, build_date: first_version["built_at"]}
      spec_attributes.each  { |k,v| attribs[k] = gem_data[v]}
      GemSpec.create!(attribs)
    end
    fetch_owners(laser_gem)
    fetch_and_spec_deps(laser_gem, gem_data["dependencies"]["runtime"] )
  end

  # create ownerships for each rubygems owner
  def fetch_owners(laser_gem)
    return unless laser_gem.ownerships.where(rubygem_owner: true).empty?
    owner_array = get_owners_from_api(laser_gem.name)
    owner_array.each do |owner|
      gem_handle = owner["handle"]
      email = owner["email"]
      ownership = Ownership.find_or_create_by!(laser_gem_id: laser_gem.id, email: email)
      ownership.update(rubygem_owner: true, gem_handle: gem_handle)
    end
    laser_gem.dependencies.each { |dep| fetch_owners(dep) }
  end

  def fetch_and_spec_deps(laser_gem, runtime_deps)
    runtime_deps.each do |gem_dep|
      dep_name = gem_dep["name"]
      ver = gem_dep["requirements"]
      lg_dep = LaserGem.find_or_create_by!(name: dep_name)
      begin
        laser_gem.register_dependency(lg_dep, ver) unless GemDependency.where("laser_gem_id = ? and dependency_id = ?", laser_gem.id, lg_dep.id).exists?
      rescue ActiveRecord::RecordInvalid => e
        puts dep_name + " invalid " + e.message
      end
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
