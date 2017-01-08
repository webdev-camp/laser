require "gem_loader"
require "git_loader"

RSpec.describe GemLoader , :vcr do
  describe "#get_owners_from_api" do
    it "fetches using the client" do
      loader = GemLoader.new
      expect(loader.get_owners_from_api("rails").length).to be 13
    end

    it "gets owner data" do
      loader = GemLoader.new
      expect(loader.get_owners_from_api("rails").first["email"]).to eq "kaspth@gmail.com"
    end
  end

  describe "#fetch_owners" do
    before :example do
      @loader = GemLoader.new
    end
    it "saves an instance of ownership for each owner in the array" do
      laser_gem = LaserGem.create(name: "rails")
      expect(Ownership.count).to eq 0
      @loader.update_owners(laser_gem)
      expect(Ownership.count).to eq 13
    end


    it "correctly populates ownerships for each laser_gem"  do
      laser_gem = LaserGem.create(name: "rails")
      @loader.update_owners(laser_gem)
      owner_handles =
        [ "kaspth", "matthewd", "senny", "chancancode", "pixeltrix", nil, "webster132",
          "fxn", "tenderlove", "spastorino", "cantoniodasilva", "guilleiguaran", "rafaelfranca"]
        expect(Ownership.all.pluck(:gem_handle)).to eq owner_handles
    end

    it "saves instances of ownership for the dependents with the given laser_gem" do
      laser_gem = @loader.create_or_update_spec("tzinfo")
      @loader.update_owners(laser_gem)
      ts = LaserGem.find_by(name: "thread_safe")
      expect(ts.ownerships.count).not_to be nil
    end

    it "does not save a ownership if it already exists" do
      laser_gem = @loader.create_or_update_spec("tzinfo")
      ts = LaserGem.find_by(name: "thread_safe")
      @loader.update_owners(laser_gem)
      expect(ts.ownerships.count).not_to be nil
      num = ts.ownerships.count
      @loader.update_owners(ts)
      expect(ts.ownerships.count).to eq num
    end
  end

end
