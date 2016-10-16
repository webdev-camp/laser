RSpec.describe GemLoader do
  it "instantiates a loader" do
    expect(GemLoader.new).not_to be nil
  end

  describe "#get_spec_by_name" do
    it "fetches using the client" do
      api_response = { "name" => "rails" }
      client = instance_double("Gems::Client", info: api_response)
      loader = GemLoader.new(client: client)
      expect(loader.get_spec_by_name("rails")).to be api_response
    end
  end

  it "returns an error when the API doesn't respond" do
    api_response =  
      "SocketError: Failed to open TCP connection to rubygems.org:443 (getaddrinfo: Name or service not known)"
    client = instance_double("Gems::Client", info: api_response)
    loader = GemLoader.new(client: client)
    expect(loader.get_spec_by_name("rails")).to be api_response
  end


  describe "#populate_data" do
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
      expect { loader.populate_data(laser_gem) }.to raise_error(ActiveRecord::RecordInvalid)
    end

   xit "saves an instance of GemSpec for each laser_gem" do
      loader = GemLoader.new
      laser_gem = LaserGem.create!(name: "activesupport")
      loader.populate_data(laser_gem)
      expect(GemSpec.exists?(name: "activesupport")).to be true
    end

    xit "correctly populates GemSpec for each laser_gem" do
      loader = GemLoader.new
      laser_gem = LaserGem.create!(name: "activesupport")
      loader.populate_data(laser_gem)
      as_gem = GemSpec.find_by(name: "activesupport")
      expect(as_gem.name).to eq "activesupport"
      expect(as_gem.rubygem_uri).to eq "https://rubygems.org/gems/activesupport"
    end

    xit "saves instances of LaserGem for the dependents of the given laser_gem that dont already exist" do
      loader = GemLoader.new
      laser_gem = LaserGem.create!(name: "activesupport")
      loader.populate_data(laser_gem)
      expect(LaserGem.exists?(name: "minitest")).to be true
    end

    xit "saves instances of GemDependency for the dependents with the given laser_gem" do
      loader = GemLoader.new
      laser_gem = LaserGem.create!(name: "activesupport")
      loader.populate_data(laser_gem)
      expect(laser_gem.dependencies.map(&:name)).to eq ["concurrent-ruby", "i18n", "minitest", "tzinfo"]
    end

    xit "calls populate_data recursively for the dependents of the given laser_gem, creating their GemSpec's and GemDependencies with their depenendents" do
      loader = GemLoader.new
      laser_gem = LaserGem.create!(name: "activesupport")
      loader.populate_data(laser_gem)
      dep = LaserGem.find_by(name: "tzinfo")
      dep_spec = GemSpec.find_by(name: "tzinfo")
      expect(dep_spec.name).to eq "tzinfo"
      expect(dep_spec.rubygem_uri).to eq "https://rubygems.org/gems/tzinfo"
      expect(dep.dependencies.map(&:name)).to eq ["thread_safe"]

    end
  end
end
