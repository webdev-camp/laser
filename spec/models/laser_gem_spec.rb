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
    laser_gem = build :laser_gem, name: "hstglsnfmndvbdkjsdkfjdvjdfjdvkdjkkdjfkj"*3
    expect(laser_gem.save).to be false
  end

  it "checks laser-gem has a gem spec" do
    laser_gem_with_spec = create :laser_gem_with_spec
    expect(laser_gem_with_spec.gem_spec).not_to eq nil
  end

  describe "#register_dependency" do
    it "creates a gem dependency" do
      laser_gem = create :laser_gem
      laser_gem2 = create :laser_gem
      laser_gem.register_dependency(laser_gem2, "1.0.0")
      expect(laser_gem.gem_dependencies.map(&:dependency)).to eq [laser_gem2]
    end

    it "does not allow a gem to be added as a dependency to the same parent gem twice" do
      laser_gem = create :laser_gem
      laser_gem2 = create :laser_gem
      laser_gem.register_dependency(laser_gem2, "1.0.0")
      expect(laser_gem.gem_dependencies.count).to eq 1
      expect { laser_gem.register_dependency(laser_gem2, "2.0.0") }
      .to raise_error(ActiveRecord::RecordInvalid)
      laser_gem.reload
      expect(laser_gem.gem_dependencies.count).to eq 1
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
