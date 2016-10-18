RSpec.describe GitLoader do
  it "instantiates a loader" do
    expect(GitLoader.new).not_to be nil
  end

  it "saves an instance of GemGit for each laser_gem" do
     loader = GitLoader.new
     laser_gem = create :laser_gem_with_source_code_uri, name: "rails"
     loader.populate_data(laser_gem)
     expect(GemGit.exists?(name: "rails/rails")).to be true
  end
end
