require "git_loader"
require "gem_loader"

RSpec.describe GitLoader  , :vcr do
  describe "#fetch_and_create_gem_git"  do
    it "saves an instance of GemGit for each laser_gem" do
      loader = GitLoader.new
      loader2 = GemLoader.new
      laser_gem = LaserGem.create!(name: "tzinfo")
      loader2.fetch_and_create_gem_spec(laser_gem)
      loader.fetch_and_create_gem_git(laser_gem)
      expect(GemGit.exists?(name: "tzinfo/tzinfo")).to be true
    end
  end
  describe "#fetch_and_create_gem_git" do
    it "calls fetch_and_create_gem_git recursively for the dependents of the given laser_gem, creating their GemGits and ownerships"  do
      loader = GemLoader.new
      laser_gem = LaserGem.create(name: "tzinfo")
      loader.fetch_and_create_gem_spec(laser_gem)
      loader2 = GitLoader.new
      loader2.fetch_and_create_gem_git(laser_gem)
      expect(GemGit.exists?(name: "tzinfo/tzinfo")).to be true
      laser_gem.reload
      expect(laser_gem.gem_git).not_to be nil
      expect(GemGit.exists?(name: "ruby-concurrency/thread_safe")).to be true
      expect(laser_gem.dependencies.map(&:name)).to eq ["thread_safe"]
      ts = LaserGem.find_by(name: "thread_safe")
      expect(ts.ownerships.count).not_to be 0
    end
  end

  describe "#fetch_commit_activity_year"  do
    before :example do
      @loader = GitLoader.new
    end

    it "returns nil if repo name empty or invalid" do
      laser_gem = LaserGem.create(name: "letmein")
      create :gem_spec,
        laser_gem: laser_gem,
        source_code_uri: "www.gi.com/tzinfo/tzn"
      expect(@loader.fetch_commit_activity_year(laser_gem)).to be nil
    end

    it "retuns nil if repo is valid but doesnt exist"  do
      loader2 = GemLoader.new
      laser_gem = LaserGem.create(name: "paranoid")
      loader2.fetch_and_create_gem_spec(laser_gem)
      @loader.fetch_and_create_gem_git(laser_gem)
      expect(@loader.fetch_commit_activity_year(laser_gem)).to be nil
    end

    it "returns non-empty array"  do
      laser_gem = LaserGem.create!(name: "tzinfo")
      loader2 = GemLoader.new
      loader2.fetch_and_create_gem_spec(laser_gem)
      @loader.fetch_and_create_gem_git(laser_gem)
      laser_gem.reload
      @loader.fetch_commit_activity_year(laser_gem)
      laser_gem.reload
      expect((laser_gem.gem_git.commit_dates_year).any?).to be true
    end
  end

end
