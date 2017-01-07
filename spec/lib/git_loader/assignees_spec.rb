require "git_loader"
require "gem_loader"

RSpec.describe GitLoader  , :vcr do

  describe "#fetch_assignees" do
    before :example do
      @loader = GitLoader.new
      @gemloader = GemLoader.new
    end
    it "saves an instance of ownership for each assignee in the array" do
      tz = @gemloader.create_or_update_spec("tzinfo")
      @loader.fetch_assignees(tz)
      expect(Ownership.count).not_to be 0
      expect(Ownership.count).not_to be nil
    end

    it "updates an existing ownership if the handles match" do
      tz = @gemloader.create_or_update_spec("tzinfo")
      expect(Ownership.where(["github_owner = ?", true]).count).to be 0
      @loader.fetch_assignees(tz)

      expect(Ownership.where(["github_owner = ? and rubygem_owner = ?", true, true]).count).not_to be 0
    end

    it "correctly populates ownerships for each laser_gem"  do
      tz = @gemloader.create_or_update_spec("tzinfo")
      repo_name = @loader.parse_git_uri(tz)
      array = @loader.get_owners_from_github(repo_name)
      @loader.fetch_assignees(tz)
      array.each { |a| expect(Ownership.where(["git_handle = ?", a[0]])[0].git_handle).to eq array[0][0] }
    end

    it "saves instances of ownership for the dependents with the given laser_gem" do
      tz = @gemloader.create_or_update_spec("tzinfo")
      ts = LaserGem.find_by(name: "thread_safe")
      @loader.fetch_assignees(tz)
      expect(ts.ownerships.count).not_to be 0
    end

    it "does not save a ownership if it already exists" do
      tz = @gemloader.create_or_update_spec("tzinfo")
      ts = LaserGem.find_by(name: "thread_safe")
      @loader.fetch_assignees(tz)
      num = ts.ownerships.count
      @loader.fetch_assignees(ts)
      expect(ts.ownerships.count).to eq num
    end
  end

end
