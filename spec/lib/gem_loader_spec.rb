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

    it "returns an error when the API doesn't respond" do
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

      it "updates and saves gem_spec_id for ownership if laser_gem has a gem_spec", :ci => true  do
        laser_gem = LaserGem.create(name: "tzinfo")
        @loader.fetch_and_create_gem_spec(laser_gem)
        @loader.fetch_owners(laser_gem)
        ownership = laser_gem.ownerships.first
        expect(ownership.gem_spec.id).not_to be nil
      end

      it "updates and saves gem_git_id for ownership if laser_gem has a gem_git", :ci => true do

        laser_gem = LaserGem.create(name: "tzinfo")
        loader2 = GitLoader.new
        loader2 = fetch_and_create_gem_git(laser_gem)
        @loader.fetch_and_create_gem_spec(laser_gem)
        @loader.fetch_owners(laser_gem)
        ownership = laser_gem.ownerships.first
        expect(ownership.gem_git.id).not_to be nil
      end

      it "saves instances of ownership for the dependents with the given laser_gem", :ci => true do
        laser_gem = LaserGem.create!(name: "tzinfo")
        @loader.fetch_and_create_gem_spec(laser_gem)
        @loader.fetch_owners(laser_gem)
        tz = LaserGem.find_by(name: "thread_safe")
        expect(tz.ownerships.count).not_to be nil
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

      it "calls fetch_and_create_gem_spec recursively for the dependents of the given laser_gem, creating their ownerships", :ci => true
    end

    describe "#fetch_and_create_gem_spec" do
      it "returns a validation error when API response is invalid" do
        api_response = { 
          "name" => "rails",
          "info" => "some information",
          "version" => "",
          # Version is empty string
          "version_downloads" => "12345",
          "downloads" => "123456",
          "project_uri" => "www.rubygems.org/rails",
          "documentation_uri" => "www.blah",
          "source_code_uri" => "www.github.blah",
          "homepage_uri" => "www.rails.org",
        }
        client = instance_double("Gems::Client", info: api_response)
        loader = GemLoader.new(client: client)
        laser_gem = LaserGem.create!(name: "rails")
        expect { loader.fetch_and_create_gem_spec(laser_gem) }.to raise_error(ActiveRecord::RecordInvalid)
      end

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
        dep_gem = LaserGem.create!(name: "thread-safe")
        laser_gem.register_dependency(dep_gem, "1.1.1")
        expect{ loader.fetch_and_create_gem_spec(laser_gem) }.not_to raise_error
      end

      it "fetches owners of the LaserGem and creates ownerships", :ci => true do
        loader = GemLoader.new
        laser_gem = LaserGem.create!(name: "tzinfo")
        loader.fetch_and_create_gem_spec(laser_gem)
        expect(laser_gem.ownerships.count).to be > 0
      end

      it "calls fetch_and_create_gem_spec recursively for the dependents of the given laser_gem, creating their GemSpecs and GemDependencies with their depenendents", :ci => true  do
        loader = GemLoader.new
        laser_gem = LaserGem.create!(name: "activesupport")
        loader.fetch_and_create_gem_spec(laser_gem)
        dep = LaserGem.find_by(name: "tzinfo")
        dep_spec = GemSpec.find_by(name: "tzinfo")
        expect(dep_spec.name).to eq "tzinfo"
        expect(dep_spec.rubygem_uri).to eq "https://rubygems.org/gems/tzinfo"
        expect(dep.dependencies.map(&:name)).to eq ["thread_safe"]
      end
    end
  end
end
