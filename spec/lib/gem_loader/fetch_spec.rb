require "gem_loader"
require "git_loader"

RSpec.describe GemLoader , :vcr do

  describe "#fetch_and_create_gem_spec" do
    it "saves an instance of GemSpec for each laser_gem" do
      loader = GemLoader.new
      laser_gem = LaserGem.create!(name: "activesupport")
      loader.fetch_and_create_gem_spec(laser_gem)
      expect(GemSpec.exists?(name: "activesupport")).to be true
    end

    it "does not create a laser_gem for gem name that do not exists" do
      GemLoader.new.create_or_update_spec("pails")
      expect( LaserGem.find_by(name: "pails") ).to be nil
    end

    it "correctly populates GemSpec for each laser_gem"  do
      loader = GemLoader.new
      laser_gem = LaserGem.create!(name: "activesupport")
      loader.fetch_and_create_gem_spec(laser_gem)
      as_gem = GemSpec.find_by(name: "activesupport")
      expect(as_gem.name).to eq "activesupport"
      expect(as_gem.rubygem_uri).to eq "https://rubygems.org/gems/activesupport"
    end

    it "touches existing laser_gem"  do
      loader = GemLoader.new
      laser_gem = LaserGem.create!(name: "activerecord" , updated_at: Time.now - 2.days)
      loader.fetch_and_create_gem_spec(laser_gem)
      laser_gem.reload
      expect(Time.now - laser_gem.updated_at).to be <= 30
    end

    it "saves instances of LaserGem for the dependents of the given laser_gem that dont already exist"  do
      loader = GemLoader.new
      laser_gem = LaserGem.create!(name: "activesupport")
      loader.fetch_and_create_gem_spec(laser_gem)
      expect(LaserGem.exists?(name: "minitest")).to be true
    end

    it "saves instances of GemDependency for the dependents with the given laser_gem"  do
      loader = GemLoader.new
      laser_gem = LaserGem.create!(name: "activesupport")
      loader.fetch_and_create_gem_spec(laser_gem)
      expect(laser_gem.dependencies.map(&:name)).to eq ["concurrent-ruby", "i18n", "minitest", "tzinfo"]
    end

    # The problem with this test is that if the dependency for tzinfo changes the test will no longer be effective
    it "does not save a GemDependency if it already exists" do
      loader = GemLoader.new
      laser_gem = LaserGem.create!(name: "tzinfo")
      loader.fetch_and_create_gem_spec(laser_gem)
      expect{ loader.fetch_and_create_gem_spec(laser_gem) }.not_to raise_error
    end

    it "fetches the build_date of the first version for each LaserGem" do
      loader = GemLoader.new
      laser_gem = LaserGem.create!(name: "tzinfo")
      loader.fetch_and_create_gem_spec(laser_gem)
      expect(laser_gem.gem_spec.build_date).to eq "2005-08-30T04:00:00.000Z"
    end

    it "fetches owners of the LaserGem and creates ownerships" do
      loader = GemLoader.new
      laser_gem = LaserGem.create!(name: "tzinfo")
      loader.fetch_and_create_gem_spec(laser_gem)
      expect(laser_gem.ownerships.count).to be > 0
    end

    it "calls fetch_and_create_gem_spec recursively for the dependents of the given laser_gem, creating their GemSpecs, Ownerships and GemDependencies with their depenendents"  do
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

end
