RSpec.describe Owner, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

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
end
