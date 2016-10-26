RSpec.describe Comment, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  it "has a working factory" do
    comment = build :comment
    expect(comment.save).to be true
  end

  it "can associate a laser gem with a comment" do
    laser_gem = create :laser_gem
    comment = create :comment, laser_gem: laser_gem
    expect(comment.laser_gem).to eq laser_gem
  end

  it "can associate an user with a comment" do
    user = create :user
    comment = create :comment, user: user
    expect(comment.user).to eq user
  end

  it "checks the presence of body attribute" do
    comment = build :comment, body: ""
    expect(comment.save).to be false
  end

  it "checks the minimum length of body attribute" do
    comment = build :comment, body: ("t" * 6)
    expect(comment.save).to be false
  end

  it "checks the maximum length of body attribute" do
    comment = build :comment, body: ("t" * 301)
    expect(comment.save).to be false
  end
end
