RSpec.describe LaserGem, type: :model do
  before(:example) do
    @laser_gem = create :laser_gem_with_dependencies
  end

  it "has working factory with dependencies" do
    expect(@laser_gem.gem_dependencies.length).to be 5
  end

  it "has unique ids for each gem dependency" do
    expect(@laser_gem.gem_dependencies.collect{|dep| dep.id }.uniq.length).to be 5
  end

  it "has the same parent laser gem for each gem dependency" do
    expect(@laser_gem.gem_dependencies.collect{|dep| dep.laser_gem.name }.uniq.length).to be 1
  end

  it "ensures the parent laser gem for each gem dependency is (the original) laser_gem" do
    @laser_gem.gem_dependencies.each do |dep|
      expect(dep.laser_gem.name).to be @laser_gem.name
    end
  end

  it "checks that all the gem dependecies are unique" do
    expect(@laser_gem.gem_dependencies.collect{|dep| dep.dependency.name }.uniq.length).to be 5
  end

  it "allows the dependency to be used as a method" do
    expect(@laser_gem.dependencies.collect{|lgem| lgem.name }.uniq.length).to be 5
    expect(@laser_gem.dependencies.collect{|lgem| lgem.id }.uniq.length).to be 5
  end
end

RSpec.describe LaserGem, type: :model do
  before(:example) do
    @laser_gem = create :laser_gem_with_dependents
  end

  it "has working factory with dependents" do
    expect(@laser_gem.gem_dependents.length).to be 5
  end

  it "has unique ids for each gem dependents" do
    expect(@laser_gem.gem_dependents.collect{|dept| dept.id }.uniq.length).to be 5
  end

  it "has the same parent laser gem for each gem dependents" do
    expect(@laser_gem.gem_dependents.collect{|dept| dept.laser_gem.name }.uniq.length).to be 5
  end

  it "ensures the parent laser gem for each gem dependents is (the original) laser_gem" do
    @laser_gem.gem_dependents.each do |dept|
      expect(dept.dependency.name).to eq @laser_gem.name
    end
  end
end
