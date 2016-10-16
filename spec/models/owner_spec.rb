RSpec.describe Owner, type: :model do

  it "has working factory" do
    owner = build :owner
    expect(owner.save).to be true
  end

  it "checks name attribute" do
    owner = build :owner, name: ""
    expect(owner.save).to be false
  end

  it "checks email attribute" do
    owner = build :owner, email: ""
    expect(owner.save).to be false
  end

  it "checks email attribute - no @" do
    owner = build :owner, email: "myemail.com"
    expect(owner.save).to be false
  end

  it "checks email attribute - no .end" do
    owner = build :owner, email: "myemail@"
    expect(owner.save).to be false
  end

  it "is not valid without a laser_gem" do
    owner = build :owner, laser_gem: nil
    expect(owner.save).to be false
  end
end
