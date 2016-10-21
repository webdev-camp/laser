RSpec.describe GitLoader do
  it "instantiates a loader" do
    expect(GitLoader.new).not_to be nil
  end

  describe "#parse_git_uri" do
    it "does not parse if gem_spec not present" do
      loader = GitLoader.new
      laser_gem = create :laser_gem
      expect(loader.parse_git_uri(laser_gem)).to be nil
    end

    it "does not parse if source_code_uri is nil" do
      loader = GitLoader.new
      laser_gem_w_spec = create :gem_spec, source_code_uri: "nil" 
      laser_gem = laser_gem_w_spec.laser_gem
      expect(loader.parse_git_uri(laser_gem)).to be nil
    end

    it "does not parse if source_code_uri does not include 'github'" do
      loader = GitLoader.new
      laser_gem_w_spec = create :gem_spec, source_code_uri: "www.rails.org"
      laser_gem = laser_gem_w_spec.laser_gem
      expect(loader.parse_git_uri(laser_gem)).to be nil
    end

    it "does not parse if source_code_uri is incorrect format" do
      loader = GitLoader.new
      laser_gem_w_spec = create :gem_spec, source_code_uri: "www.github.com/mail/mail/"
      laser_gem = laser_gem_w_spec.laser_gem
      expect(loader.parse_git_uri(laser_gem)).to be nil
    end

    it "returns repo name if source_code_uri is in correct format" do
      loader = GitLoader.new
      laser_gem_w_spec = create :gem_spec, source_code_uri: "https://github.com/ruby-gem/rails"
      laser_gem = laser_gem_w_spec.laser_gem
      expect(loader.parse_git_uri(laser_gem)).to eq "ruby-gem/rails"
    end
  end

  describe "#fetch_and_create_gem_git", :ci => true  do
    it "saves an instance of GemGit for each laser_gem" do
      loader = GitLoader.new
      laser_gem = create :laser_gem_with_source_code_uri, name: "rails"
      loader.fetch_and_create_gem_git(laser_gem)
      expect(GemGit.exists?(name: "rails/rails")).to be true
    end
  end

  describe "#fetch_and_create_gem_git", :ci => true do
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
end
