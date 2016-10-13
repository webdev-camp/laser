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
end
