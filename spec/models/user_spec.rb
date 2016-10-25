RSpec.describe User, type: :model do
  it "has working factory" do
    user = build :user
    expect(user.save).to be true
  end

  xit "checks name attribute" do
    user = build :user, name: ""
    expect(user.save).to be false
  end
end
