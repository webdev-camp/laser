RSpec.describe Ownership, type: :model do

  it "has working factory" do
    owner = build :ownership
    expect(owner.save).to be true
  end

  it "checks name attribute" do
    owner = build :ownership, name: ""
    expect(owner.save).to be false
  end

  it "checks email attribute" do
    owner = build :ownership, email: ""
    expect(owner.save).to be false
  end

  it "checks email attribute - no @" do
    owner = build :ownership, email: "myemail.com"
    expect(owner.save).to be false
  end

  it "checks email attribute - no .end" do
    owner = build :ownership, email: "myemail@"
    expect(owner.save).to be false
  end

  it "is not valid without a laser_gem" do
    owner = build :ownership, laser_gem: nil
    expect(owner.save).to be false
  end
end
