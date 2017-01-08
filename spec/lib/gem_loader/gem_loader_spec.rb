require "gem_loader"
require "git_loader"

RSpec.describe GemLoader , :vcr do
  before :each do
    @loader = GemLoader.new
  end

  it "instantiates a loader" do
    expect(@loader).not_to be nil
  end

  describe "#get_spec_from_api" do
    it "fetches using the client" do
      expect(@loader.get_spec_from_api("rails").length).to be 19
    end

    it "returns nil when the API doesn't respond" do
      loader = GemLoader.new
      expect(loader.get_spec_from_api("pails")).to be nil
    end
  end

  describe "#get_build_start_from_api" do
    it "fetches build date of first version from api" do
      loader = GemLoader.new
      current, first = loader.get_build_dates_api("tzinfo")
      expect(first).to eq "2005-08-30T04:00:00.000Z"
      expect(current).to eq "2014-08-08T00:00:00.000Z"
    end
  end

  describe "#create_or_update_spec"  do
    before :example do
      @loader = GemLoader.new
    end
    it "returns nil if laser_gem.name is not a valid gem name"  do
      expect(@loader.create_or_update_spec("sassie")).to eq nil
    end
    it "creates a gem if no gem of the name exists"  do
      @loader.create_or_update_spec("sass")
      expect(LaserGem.where(name: "sass").exists?).to be true
    end

    it "creates laser gem and gem spec for dependencies if they dont exist"  do
      @loader.create_or_update_spec("bootstrap-sass")
      laser_gem = LaserGem.find_by(name: "sass")
      expect(LaserGem.where(name: "sass").exists?).to be true
      expect(Ownership.where(laser_gem_id: laser_gem.id).exists?).to be true
      expect(laser_gem.gem_spec).not_to be nil
    end

    it "updates attributes, build date and ownerships for a vaild gem if it already exists"  do
      laser_gem = @loader.create_or_update_spec("activesupport")
      laser_gem.gem_spec.update(total_downloads: 3, build_date: "2010-09-22T04:00:00.000Z")
      laser_gem.reload
      expect(laser_gem.gem_spec.total_downloads).to eq 3
      @loader.create_or_update_spec("activesupport")
      laser_gem.reload
      expect(laser_gem.gem_spec.total_downloads).not_to eq 3
      expect(laser_gem.gem_spec.build_date).not_to eq "2010-09-22T04:00:00.000Z"

    end

    it "updates the attributes for all of the gem dependencies that do exist" do
      LaserGem.create!(name: "activesupport")
      @loader.create_or_update_spec("activesupport")
      expect(LaserGem.where(name: "tzinfo").exists?).to be true
      dep = LaserGem.find_by(name: "tzinfo")
      fake_date = "2010-09-22T04:00:00.000Z"
      dep.gem_spec.update(total_downloads: 3, build_date: fake_date , updated_at: 9.days.ago)
      @loader.create_or_update_spec("activesupport")
      dep.reload
      expect(dep.gem_spec.total_downloads).not_to eq 3
      expect(dep.gem_spec.build_date).not_to eq fake_date
    end
  end
end
