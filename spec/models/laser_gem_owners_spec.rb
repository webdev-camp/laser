RSpec.describe LaserGem, type: :model do
  it "has a factory for this particular relation" do
    laser_gem = create :laser_gem_with_owners
    expect(laser_gem.ownerships.first.laser_gem_id).to be laser_gem.id
  end

  it "create ownerships with owners" do
    laser_gem = create :laser_gem_with_owners
    expect(laser_gem.owners.length).to be 1
  end

  it "creates ownerships without owners" do
    laser_gem = create :laser_gem_with_ownership
    expect(laser_gem.owners.length).to be 0
  end

  it "connect_ownerships method it's working" do
    laser_gem = create :laser_gem_with_ownership
    user = create :user, email: laser_gem.ownerships.first.email
    user.connect_ownerships
    expect(laser_gem.owners.length).to be 1
  end
end
