RSpec.describe User, type: :model do
  it "has working factory" do
    user = build :user
    expect(user.save).to be true
  end

  it "checks name attribute" do
    user = build :user, name: ""
    expect(user.save).to be false
  end

  it "checks that a new user has no ownerships" do
    user = create :user
    expect(user.ownerships.length).to be 0
  end

  it "verifies ownership associations" do
    ownership = create :ownership
    user = ownership.owner
    expect(user.laser_gems.include?(ownership.laser_gem)).to be true
  end

  it "checks that an user has an ownership" do
    ownership = create :ownership, owner: nil
    user = create :user, email: ownership.email
    user.connect_ownerships
    expect(user.ownerships.length).to be 1
    expect(user.laser_gems.length).to be 1
  end
end
