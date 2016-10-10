
RSpec.describe GemDependency, type: :model do
  it "has a working factory" do
    gem_dependency = build :gem_dependency
    expect(gem_dependency.save).to be true
  end

  it "is not valid without both a laser_gem and a gem_dependency" do
    gem_dependency = build :gem_dependency, laser_gem: nil, dependency: nil
    expect(gem_dependency.save).to be false
    gem_dependency = build :gem_dependency, laser_gem: nil
    expect(gem_dependency.save).to be false
    gem_dependency = build :gem_dependency, dependency: nil
    expect(gem_dependency.save).to be false
  end

  it "it is not valid without a version" do
    gem_dependency = build :gem_dependency, version: ""
    expect(gem_dependency.save).to be false
  end
end
