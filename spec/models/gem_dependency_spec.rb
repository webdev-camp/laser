
RSpec.describe GemDependency, type: :model do
  it "has a working factory" do
    gem_dependency = build :gem_dependency
    expect(gem_dependency.save).to be true
  end

  it "is not valid without both a laser_gem and a gem_dependency" do
    gem_dependency = build :gem_dependency, laser_gem: nil, dependency: nil
    expect(gem_dependency.save).to be false
  end

  it "is not valid without a laser_gem" do
    gem_dependency = build :gem_dependency, laser_gem: nil
    expect(gem_dependency.save).to be false
  end

  it "is not valid without a dependency" do
    gem_dependency = build :gem_dependency, dependency: nil
    expect(gem_dependency.save).to be false
  end

  it "it is not valid without a version" do
    gem_dependency = build :gem_dependency, version: ""
    expect(gem_dependency.save).to be false
  end

  describe "#not_self_dependent" do
    it "prevents a laser_gem from having itself as a dependency" do
      laser_gem = create :laser_gem
      expect { laser_gem.register_dependency(laser_gem, "1.2.0") }
      .to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
