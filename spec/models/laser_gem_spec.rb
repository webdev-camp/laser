RSpec.describe LaserGem, type: :model do
  it "has working factory" do
    laser_gem = build :laser_gem
    expect(laser_gem.save).to be true
  end

  it "checks name attribute" do
    laser_gem = build :laser_gem, name: ""
    expect(laser_gem.save).to be false
  end

  it "validates low values for length" do
    laser_gem = build :laser_gem, name: "t"
    expect(laser_gem.save).to be false
  end

  it "validates high values for length" do
    laser_gem = build :laser_gem, name: "hstglsnfmndvbdkjsdkfjdvjdfjdvkdjkkdjfkj"
    expect(laser_gem.save).to be false
  end

  describe "#register_dependency" do
    it "creates a gem dependency" do
      laser_gem = create :laser_gem
      laser_gem2 = create :laser_gem
      laser_gem.register_dependency(laser_gem2, "1.0.0")
      expect(laser_gem.gem_dependencies.map(&:dependency)).to eq [laser_gem2]
    end
  end

  describe "#remove_dependency" do
    it "deletes a gem dependency" do
      laser_gem = create :laser_gem
      laser_gem2 = create :laser_gem
      laser_gem.register_dependency(laser_gem2, "1.0.0")
      expect(laser_gem.gem_dependencies.map(&:dependency)).to eq [laser_gem2]
      laser_gem.remove_dependency(laser_gem2)
      expect(laser_gem.gem_dependencies.map(&:dependency)).to eq []
    end
  end
end
