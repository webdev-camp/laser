RSpec.describe GitLoader do
  it "instantiates a loader" do
    expect(GitLoader.new).not_to be nil
  end

  it "saves an instance of GemGit for each laser_gem" do
    loader = GitLoader.new
    laser_gem = create :laser_gem_with_source_code_uri, name: "rails"
    loader.fetch_and_create_gem_git(laser_gem)
    expect(GemGit.exists?(name: "rails/rails")).to be true
  end

  it "calls fetch_and_create_gem_git recursively for the dependents of the given laser_gem, creating their GemGits", :ci => true  do
    loader = GemLoader.new
    laser_gem = LaserGem.create(name: "tzinfo")
    loader.fetch_and_create_gem_spec(laser_gem)
    loader2 = GitLoader.new
    loader2.fetch_and_create_gem_git(laser_gem)
    expect(GemGit.exists?(name: "tzinfo/tzinfo")).to be true
    expect(GemGit.exists?(name: "ruby-concurrency/thread_safe")).to be true
    expect(laser_gem.dependencies.map(&:name)).to eq ["thread_safe"]
  end
end
