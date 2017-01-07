require "git_loader"
require "gem_loader"

RSpec.describe GitLoader  , :vcr do
  it "instantiates a loader" do
    expect(GitLoader.new).not_to be nil
  end

  describe "#get_git_from_api" do
    it "returns nil if api response is an error" do
      repo_name = "xspond/paranoid"
      loader = GitLoader.new
      expect(loader.get_git_from_api(repo_name)).to be nil
    end
  end

  it "fetches owners of the LaserGem and creates ownerships" do
    tz = GemLoader.new.create_or_update_spec("tzinfo")
    GitLoader.new.fetch_assignees(tz)
    expect(Ownership.count).not_to be 0
    expect(Ownership.count).not_to be nil
  end

  describe "#update_or_create_git"  do
    before :example do
      @loader = GitLoader.new
      @gemloader = GemLoader.new
    end

    it "updates existing gem_gits with owners, yearly commits and git data"  do
      laser_gem = @gemloader.create_or_update_spec("tzinfo")
      @loader.update_or_create_git(laser_gem)
      expect(laser_gem.gem_spec).not_to be nil
      laser_gem.gem_git.update(stargazers_count: 1, commit_dates_year: [1,2,3], forks_count: 666)
      laser_gem.reload
      expect(laser_gem.gem_git.stargazers_count).to eq 1
      @loader.update_or_create_git(laser_gem)
      laser_gem.gem_git.reload
      expect(laser_gem.gem_git.stargazers_count).not_to eq 1
      expect(laser_gem.gem_git.forks_count).not_to eq 666
      expect(laser_gem.gem_git.commit_dates_year).not_to eq [1,2,3]
    end

    it "creates a gem_git if one does not exsist and populates year of commits, owners and git data"  do
      laser_gem = @gemloader.create_or_update_spec("tzinfo")
      expect(laser_gem.gem_spec).not_to be nil
      @loader.update_or_create_git(laser_gem)
      laser_gem.gem_git.reload
      expect(laser_gem.gem_git).not_to be nil
      expect(laser_gem.gem_git.stargazers_count).not_to be nil
      expect(laser_gem.gem_git.forks_count).not_to be nil
      expect(laser_gem.gem_git.commit_dates_year).not_to be nil
      expect(Ownership.where(["laser_gem_id = ?", laser_gem.id]).any?).to be true
    end
  end

  describe "#github_repo_name_candidates" do
    before :example do
      @loader = GitLoader.new
    end
    it "returns empty array if no gem_spec" do
      laser_gem = LaserGem.new(name: "tzinfo")
      expect(@loader.github_repo_name_candidates(laser_gem)).to eq []
    end
    it "returns empty array if gem_spec has no uris" do
      laser_gem = LaserGem.new(name: "tzinfo")
      laser_gem.gem_spec = GemSpec.new
      expect(@loader.github_repo_name_candidates(laser_gem)).to eq []
    end
    it "returns empty array if gem_spec has no valid uris" do
      laser_gem = LaserGem.new(name: "tzinfo")
      laser_gem.gem_spec = GemSpec.new(
        homepage_uri: 'twinkle',
      )
      expect(@loader.github_repo_name_candidates(laser_gem)).to eq []
    end

    it "returns array of valid repo names if any field has a valid uri" do
      laser_gem = LaserGem.new(name: "tzinfo")
      laser_gem.gem_spec = GemSpec.new(
        homepage_uri: 'www.github.com/home/uri',
        documentation_uri: 'www.github.com/docs/uri#README',
        bug_tracker_uri: 'www.github.com/home/project/issues',
      )
      expect(@loader.github_repo_name_candidates(laser_gem)).to eq [
        "home/uri", "docs/uri", "home/project"
      ]
    end
  end

end
