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
      @loader.update_owners(tz , "tzinfo/tzinfo")
      expect(Ownership.count).not_to be 0
      expect(Ownership.count).not_to be nil
    end

    it "updates an existing ownership if the handles match" do
      tz = @gemloader.create_or_update_spec("tzinfo")
      expect(tz.ownerships.count).to be 1
      @loader.update_owners(tz , "tzinfo/tzinfo")
      expect(tz.ownerships.count).to be 2
    end

    it "correctly populates ownerships for each laser_gem"  do
      tz = @gemloader.create_or_update_spec("tzinfo")
      repo_name = @loader.parse_git_uri(tz)
      array = @loader.get_owners_from_github(repo_name)
      @loader.update_owners(tz , "tzinfo/tzinfo")
      array.each { |a| expect(Ownership.where(["git_handle = ?", a[0]])[0].git_handle).to eq array[0][0] }
    end

    it "saves instances of ownership for the dependents with the given laser_gem" do
      tz = @gemloader.create_or_update_spec("tzinfo")
      ts = LaserGem.find_by(name: "thread_safe")
      @loader.update_owners(tz , "tzinfo/tzinfo")
      expect(ts.ownerships.count).not_to be 0
    end

    it "does not save a ownership if it already exists" do
      tz = @gemloader.create_or_update_spec("tzinfo")
      ts = LaserGem.find_by(name: "thread_safe")
      @loader.update_owners(tz , "tzinfo/tzinfo")
      num = ts.ownerships.count
      @loader.update_owners(tz , "ruby-concurrency/thread_safe")
      expect(ts.ownerships.count).to eq num
    end
  end

end
