RSpec.describe Comment, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

it "has working factory" do
  comment = build :comment
  expect(comment.save).to be true
end

it "checks name attribute" do
  comment = build :comment, name: ""
  expect(comment.save).to be true
end
end
