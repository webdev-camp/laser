RSpec.describe GitLoader do
  it "instantiates a loader" do
    expect(GitLoader.new).not_to be nil
  end

  it "saves an instance of GemGit for each laser_gem" do
     loader = GitLoader.new
     laser_gem = create :laser_gem, name: "rails"
     create :gem_spec,
         name: "rails",
         source_code_uri: "http://github.com/rails/rails",
         laser_gem_id: laser_gem.id
     loader.populate_data(laser_gem)
     expect(GemGit.exists?(name: "rails/rails")).to be true
  end
end
