require "git_loader"
require "gem_loader"

RSpec.describe GitLoader  , :vcr do

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

    it "returns repo name if any uris are in correct format AND are a real repo_name"  do
      make_spec homepage_uri: "www.rails.org", documentation_uri: "www.github.com/tzinfo/tzinfo", bug_tracker_uri: "https://issues/here/rails.uk"
      expect(@loader.parse_additional_uris(@laser_gem)).to eq "tzinfo/tzinfo"
    end

    it "returns nil if any uris are in correct format but arent a real repo_name"  do
      make_spec homepage_uri: "www.rails.org", documentation_uri: "www.github.com/bugsy/bugs", bug_tracker_uri: "https://issues/here/rails.uk"
      expect(@loader.parse_additional_uris(@laser_gem)).to eq nil
    end

    it "returns repo name if any uris are in correct format"  do
      make_spec homepage_uri: "www.rails.org", documentation_uri: "www.github.com", bug_tracker_uri: "https://github.com/rails/rails/issues"
      expect(@loader.parse_additional_uris(@laser_gem)).to eq "rails/rails"
    end

    it "returns repo name if any uris are in correct format"  do
      make_spec homepage_uri: "www.github.com/rails/rails", documentation_uri: "www.github.com", bug_tracker_uri: "https://com/rails/rails/issues"
      expect(@loader.parse_additional_uris(@laser_gem)).to eq "rails/rails"
    end
  end

end
