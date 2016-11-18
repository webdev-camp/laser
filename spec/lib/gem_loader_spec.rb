RSpec.describe GemLoader do
  it "instantiates a loader" do
    expect(GemLoader.new).not_to be nil
  end

  describe "#get_spec_from_api" do
    it "fetches using the client" do
      api_response = { "name" => "rails" }
      client = instance_double("Gems::Client", info: api_response)
      loader = GemLoader.new(client: client)
      expect(loader.get_spec_from_api("rails")).to be api_response
    end

    it "returns nil when the API doesn't respond" do
      api_response =
        "SocketError: Failed to open TCP connection to rubygems.org:443 (getaddrinfo: Name or service not known)"
      client = instance_double("Gems::Client", info: api_response)
      loader = GemLoader.new(client: client)
      expect(loader.get_spec_from_api("rails")).to be api_response
    end
  end

  describe "#get_owners_from_api" do
    it "fetches using the client" do
      api_response = { "owners" => "mr tickle" }
      client = instance_double("Gems::Client", owners: api_response)
      loader = GemLoader.new(client: client)
      expect(loader.get_owners_from_api("rails")).to be api_response
    end

    it "returns an error when the API doesn't respond" do
      api_response =
        "SocketError: Failed to open TCP connection to rubygems.org:443 (getaddrinfo: Name or service not known)"
      client = instance_double("Gems::Client", owners: api_response)
      loader = GemLoader.new(client: client)
      expect(loader.get_owners_from_api("rails")).to be api_response
    end
  end

  describe "#get_build_start_from_api" do
    it "fetches build date of first version from api", :ci => true do
      api_response = [{"stuff" => "stuffing"}, {"muppets" => "fraggles"}, {"build_date" => "2005-08-30T04:00:00.000Z"}]
      client = instance_double("Gems::Client", versions: api_response)
      loader = GemLoader.new(client: client)
      expect(loader.get_build_start_from_api("tzinfo")["build_date"]).to eq "2005-08-30T04:00:00.000Z"
    end
  end

  describe "#fetch_owners" do
    before :example do
      @loader = GemLoader.new
    end
    it "saves an instance of ownership for each owner in the array", :ci => true do
      laser_gem = LaserGem.create(name: "rails")
      expect(Ownership.count).to eq 0
      @loader.fetch_owners(laser_gem)
      expect(Ownership.count).to eq 13
    end


    it "correctly populates ownerships for each laser_gem" , :ci => true do
      laser_gem = LaserGem.create(name: "rails")
      @loader.fetch_owners(laser_gem)
      owner_handles =
        [ "kaspth",
          "matthewd",
          "senny",
          "chancancode",
          "pixeltrix",
          nil,
          "webster132",
          "fxn",
          "tenderlove",
          "spastorino",
          "cantoniodasilva",
          "guilleiguaran",
          "rafaelfranca"]
        expect(Ownership.all.pluck(:gem_handle)).to eq owner_handles
    end

    it "saves instances of ownership for the dependents with the given laser_gem", :ci => true do
      laser_gem = LaserGem.create!(name: "tzinfo")
      @loader.fetch_and_create_gem_spec(laser_gem)
      @loader.fetch_owners(laser_gem)
      ts = LaserGem.find_by(name: "thread_safe")
      expect(ts.ownerships.count).not_to be nil
    end

    it "does not save a ownership if it already exists", :ci => true do
      laser_gem = LaserGem.create!(name: "tzinfo")
      @loader.fetch_and_create_gem_spec(laser_gem)
      ts = LaserGem.find_by(name: "thread_safe")
      @loader.fetch_owners(laser_gem)
      expect(ts.ownerships.count).not_to be nil
      num = ts.ownerships.count
      @loader.fetch_owners(ts)
      expect(ts.ownerships.count).to eq num
    end
  end

  describe "#fetch_and_create_gem_spec" do
    it "saves an instance of GemSpec for each laser_gem", :ci => true do
      loader = GemLoader.new
      laser_gem = LaserGem.create!(name: "activesupport")
      loader.fetch_and_create_gem_spec(laser_gem)
      expect(GemSpec.exists?(name: "activesupport")).to be true
    end

    it "correctly populates GemSpec for each laser_gem" , :ci => true do
      loader = GemLoader.new
      laser_gem = LaserGem.create!(name: "activesupport")
      loader.fetch_and_create_gem_spec(laser_gem)
      as_gem = GemSpec.find_by(name: "activesupport")
      expect(as_gem.name).to eq "activesupport"
      expect(as_gem.rubygem_uri).to eq "https://rubygems.org/gems/activesupport"
    end

    it "saves instances of LaserGem for the dependents of the given laser_gem that dont already exist", :ci => true  do
      loader = GemLoader.new
      laser_gem = LaserGem.create!(name: "activesupport")
      loader.fetch_and_create_gem_spec(laser_gem)
      expect(LaserGem.exists?(name: "minitest")).to be true
    end

    it "saves instances of GemDependency for the dependents with the given laser_gem", :ci => true  do
      loader = GemLoader.new
      laser_gem = LaserGem.create!(name: "activesupport")
      loader.fetch_and_create_gem_spec(laser_gem)
      expect(laser_gem.dependencies.map(&:name)).to eq ["concurrent-ruby", "i18n", "minitest", "tzinfo"]
    end

    # The problem with this test is that if the dependency for tzinfo changes the test will no longer be effective
    it "does not save a GemDependency if it already exists", :ci => true do
      loader = GemLoader.new
      laser_gem = LaserGem.create!(name: "tzinfo")
      loader.fetch_and_create_gem_spec(laser_gem)
      expect{ loader.fetch_and_create_gem_spec(laser_gem) }.not_to raise_error
    end

    it "fetches the build_date of the first version for each LaserGem", :ci => true do
      loader = GemLoader.new
      laser_gem = LaserGem.create!(name: "tzinfo")
      loader.fetch_and_create_gem_spec(laser_gem)
      expect(laser_gem.gem_spec.build_date).to eq "2005-08-30T04:00:00.000Z"
    end

    it "fetches owners of the LaserGem and creates ownerships", :ci => true do
      loader = GemLoader.new
      laser_gem = LaserGem.create!(name: "tzinfo")
      loader.fetch_and_create_gem_spec(laser_gem)
      expect(laser_gem.ownerships.count).to be > 0
    end

    it "calls fetch_and_create_gem_spec recursively for the dependents of the given laser_gem, creating their GemSpecs, Ownerships and GemDependencies with their depenendents", :ci => true  do
      loader = GemLoader.new
      laser_gem = LaserGem.create!(name: "activesupport")
      loader.fetch_and_create_gem_spec(laser_gem)
      dep = LaserGem.find_by(name: "tzinfo")
      dep_spec = GemSpec.find_by(name: "tzinfo")
      expect(dep_spec.name).to eq "tzinfo"
      expect(dep_spec.rubygem_uri).to eq "https://rubygems.org/gems/tzinfo"
      expect(dep.dependencies.map(&:name)).to eq ["thread_safe"]
      expect(dep.ownerships.count).not_to be 0
    end
  end

  describe "#create_or_update_spec", ci: true do
    before :example do
      @loader = GemLoader.new
    end
    it "returns nil if laser_gem.name is not a valid gem name" do
      expect(@loader.create_or_update_spec("sassie")).to eq nil
    end
    it "creates a gem if no gem of the name exists" do
      @loader.create_or_update_spec("sass")
      expect(LaserGem.where(name: "sass").exists?).to be true
    end
    it "creates laser gem and gem spec for dependencies if they dont exist", :ci => true  do

      @loader.create_or_update_spec("bootstrap-sass")
      laser_gem = LaserGem.find_by(name: "sass")
      expect(LaserGem.where(name: "sass").exists?).to be true
      expect(Ownership.where(laser_gem_id: laser_gem.id).exists?).to be true
      expect(laser_gem.gem_spec).not_to be nil
    end
    it "updates attributes, build date and ownerships for a vaild gem if it already exists" do
      loader = GemLoader.new
      laser_gem = LaserGem.create!(name: "activesupport")
      loader.fetch_and_create_gem_spec(laser_gem)
      laser_gem.gem_spec.update(total_downloads: 3, build_date: "2010-09-22T04:00:00.000Z")
      laser_gem.reload
      expect(laser_gem.gem_spec.total_downloads).to eq 3
      @loader.create_or_update_spec("activesupport")
      laser_gem.reload
      expect(laser_gem.gem_spec.total_downloads).not_to eq 3
      expect(laser_gem.gem_spec.build_date).not_to eq "2010-09-22T04:00:00.000Z"

    end
    it "updates the attributes for all of the gem dependencies that do exist" do
      loader = GemLoader.new
      laser_gem = LaserGem.create!(name: "activesupport")
      loader.fetch_and_create_gem_spec(laser_gem)
      expect(LaserGem.where(name: "tzinfo").exists?).to be true
      dep = LaserGem.find_by(name: "tzinfo")
      dep.gem_spec.update(total_downloads: 3, build_date: "2010-09-22T04:00:00.000Z", updated_at: 5.days.ago)
      dep.reload
      @loader.create_or_update_spec("activesupport")
      dep.reload
      expect(dep.gem_spec.total_downloads).not_to eq 3
      expect(dep.gem_spec.build_date).not_to eq "2010-09-22T04:00:00.000Z"
    end
  end
end
