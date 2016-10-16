RSpec.describe Comment, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  it "has a working factory" do
    comment = build :comment
    expect(comment.save).to be true
  end

  it "creates a laser_gem with comment" do
    laser_gem = create :laser_gem
    comment = create :comment, laser_gem: laser_gem
    expect(comment.laser_gem).to eq laser_gem
  end
end
