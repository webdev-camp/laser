require "git_loader"

RSpec.describe GitLoader do
  it "instantiates a loader" do
    expect(GitLoader.new).not_to be nil
  end

  describe "#get_git_from_api" do
    it "returns nil if api response is an error", :ci => true do
      repo_name = "xspond/paranoid"
      loader = GitLoader.new
      expect(loader.get_git_from_api(repo_name)).to be nil
    end
  end

  describe "#fetch_assignees" do
    before :example do
      @loader = GitLoader.new
    end
    it "saves an instance of ownership for each assignee in the array", :ci => true do
      tz = LaserGem.create(name: "tzinfo")
      loader2 = GemLoader.new
      loader2.fetch_and_create_gem_spec(tz)
      @loader.fetch_assignees(tz)
      expect(Ownership.count).not_to be 0
      expect(Ownership.count).not_to be nil
    end

    it "updates an existing ownership if the handles match", :ci => true do

      tz = LaserGem.create(name: "tzinfo")
      loader2 = GemLoader.new
      loader2.fetch_and_create_gem_spec(tz)
      expect(Ownership.where(["github_owner = ?", true]).count).to be 0
      @loader.fetch_assignees(tz)

      expect(Ownership.where(["github_owner = ? and rubygem_owner = ?", true, true]).count).not_to be 0
    end

    it "correctly populates ownerships for each laser_gem" , :ci => true do
      tz = LaserGem.create(name: "tzinfo")
      loader2 = GemLoader.new
      loader2.fetch_and_create_gem_spec(tz)
      repo_name = @loader.parse_git_uri(tz)
      array = @loader.get_owners_from_github(repo_name)
      @loader.fetch_assignees(tz)
      array.each { |a| expect(Ownership.where(["git_handle = ?", a[0]])[0].git_handle).to eq array[0][0] }
    end

    it "saves instances of ownership for the dependents with the given laser_gem", :ci => true do
      tz = LaserGem.create(name: "tzinfo")
      loader2 = GemLoader.new
      loader2.fetch_and_create_gem_spec(tz)
      ts = LaserGem.find_by(name: "thread_safe")
      @loader.fetch_assignees(tz)
      expect(ts.ownerships.count).not_to be 0
    end

    it "does not save a ownership if it already exists", :ci => true do
      tz = LaserGem.create(name: "tzinfo")
      loader2 = GemLoader.new
      loader2.fetch_and_create_gem_spec(tz)
      ts = LaserGem.find_by(name: "thread_safe")
      @loader.fetch_assignees(tz)
      num = ts.ownerships.count
      @loader.fetch_assignees(ts)
      expect(ts.ownerships.count).to eq num

    end
  end

  describe "#parse_git_uri" do
    def make_spec attributes = {}
      @loader = GitLoader.new
      @laser_gem = create :laser_gem
      @spec = @laser_gem.gem_spec
      @spec.update!(attributes)
    end

    it "does not parse if gem_spec not present" do
      make_spec
      expect(@loader.parse_git_uri(@laser_gem)).to be nil
    end

    it "does not parse if source_code_uri is nil" do
      make_spec source_code_uri: "nil"
      expect(@loader.parse_git_uri(@laser_gem)).to be nil
    end

    it "does not parse if source_code_uri does not include 'github'" do
      make_spec source_code_uri: "www.rails.org"
      expect(@loader.parse_git_uri(@laser_gem)).to be nil
    end

    it "does not parse if source_code_uri is incorrect format" do
      make_spec source_code_uri: "www.github.com/mail"
      expect(@loader.parse_git_uri(@laser_gem)).to be nil
    end

    it "returns repo name if source_code_uri is in correct format" do
      make_spec source_code_uri: "https://github.com/ruby-gem/rails"
      expect(@loader.parse_git_uri(@laser_gem)).to eq "ruby-gem/rails"
    end
  end

  describe "#parse_additional_uris" do
    def make_spec attributes = {}
      @loader = GitLoader.new
      @laser_gem = create :laser_gem
      @spec = @laser_gem.gem_spec
      @spec.update!(attributes)
    end

    it "does not parse if gem_spec not present" do
      make_spec
      expect(@loader.parse_additional_uris(@laser_gem)).to be nil
    end

    it "does not parse if  homepage_ documentation_ and bug_tracker_uri  is nil" do
      make_spec homepage_uri: "nil", documentation_uri: "nil", bug_tracker_uri: "nil"
      expect(@loader.parse_additional_uris(@laser_gem)).to be nil
    end

    it "does not parse if uris do not include 'github'" do
      make_spec homepage_uri: "www.rails.org", documentation_uri: "www.doc.com/docs", bug_tracker_uri: "https://issues/here/rails.uk"
      expect(@loader.parse_additional_uris(@laser_gem)).to be nil
    end

    it "returns repo name if any uris are in correct format AND are a real repo_name" do
      make_spec homepage_uri: "www.rails.org", documentation_uri: "www.github.com/tzinfo/tzinfo", bug_tracker_uri: "https://issues/here/rails.uk"
      expect(@loader.parse_additional_uris(@laser_gem)).to eq "tzinfo/tzinfo"
    end

    it "returns nil if any uris are in correct format but arent a real repo_name" do
      make_spec homepage_uri: "www.rails.org", documentation_uri: "www.github.com/bugsy/bugs", bug_tracker_uri: "https://issues/here/rails.uk"
      expect(@loader.parse_additional_uris(@laser_gem)).to eq nil
    end

    it "returns repo name if any uris are in correct format" do
      make_spec homepage_uri: "www.rails.org", documentation_uri: "www.github.com", bug_tracker_uri: "https://github.com/rails/rails/issues"
      expect(@loader.parse_additional_uris(@laser_gem)).to eq "rails/rails"
    end

    it "returns repo name if any uris are in correct format" do
      make_spec homepage_uri: "www.github.com/rails/rails", documentation_uri: "www.github.com", bug_tracker_uri: "https://com/rails/rails/issues"
      expect(@loader.parse_additional_uris(@laser_gem)).to eq "rails/rails"
    end
  end


  describe "#fetch_and_create_gem_git", :ci => true  do
    it "saves an instance of GemGit for each laser_gem" do
      loader = GitLoader.new
      loader2 = GemLoader.new
      laser_gem = LaserGem.create!(name: "tzinfo")
      loader2.fetch_and_create_gem_spec(laser_gem)
      loader.fetch_and_create_gem_git(laser_gem)
      expect(GemGit.exists?(name: "tzinfo/tzinfo")).to be true
    end
  end

  it "fetches owners of the LaserGem and creates ownerships", :ci => true do
    tz = LaserGem.create(name: "tzinfo")
    loader = GemLoader.new
    loader.fetch_and_create_gem_spec(tz)
    loader2 = GitLoader.new
    loader2.fetch_assignees(tz)
    expect(Ownership.count).not_to be 0
    expect(Ownership.count).not_to be nil
  end

  describe "#fetch_and_create_gem_git", :ci => true do
    it "calls fetch_and_create_gem_git recursively for the dependents of the given laser_gem, creating their GemGits and ownerships", :ci => true  do
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

  describe "#fetch_commit_activity_year", ci: true do
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

    it "retuns nil if repo is valid but doesnt exist" do
      loader2 = GemLoader.new
      laser_gem = LaserGem.create(name: "paranoid")
      loader2.fetch_and_create_gem_spec(laser_gem)
      @loader.fetch_and_create_gem_git(laser_gem)
      expect(@loader.fetch_commit_activity_year(laser_gem)).to be nil
    end

    it "returns non-empty array" do
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
  describe "#update_or_create_git", ci: true do
    before :example do
      @loader = GitLoader.new
      @gemloader = GemLoader.new
    end

    it "returns nil if no valid repo name" do
      expect(@loader.update_or_create_git("sassie")).to be nil
    end

    it "updates existing gem_gits with owners, yearly commits and git data" do
      laser_gem = LaserGem.create!(name: "tzinfo")
      @gemloader.fetch_and_create_gem_spec(laser_gem)
      @loader.fetch_and_create_gem_git(laser_gem)
      laser_gem.reload
      expect(laser_gem.gem_spec).not_to be nil
      laser_gem.gem_git.update(stargazers_count: 1, commit_dates_year: [1,2,3], forks_count: 666)
      laser_gem.reload
      expect(laser_gem.gem_git.stargazers_count).to eq 1
      @loader.update_or_create_git("tzinfo")
      laser_gem.gem_git.reload
      expect(laser_gem.gem_git.stargazers_count).not_to eq 1
      expect(laser_gem.gem_git.forks_count).not_to eq 666
      expect(laser_gem.gem_git.commit_dates_year).not_to eq [1,2,3]
    end

    it "creates a gem_git if one does not exsist and populates year of commits, owners and git data" do
      laser_gem = LaserGem.create!(name: "tzinfo")
      @gemloader.fetch_and_create_gem_spec(laser_gem)
      laser_gem.reload
      expect(laser_gem.gem_spec).not_to be nil
      @loader.update_or_create_git("tzinfo")
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
