# require 'rails_helper'

RSpec.describe Announcement, type: :model do

  it "has a working factory" do
    announcement = build :announcement
    expect(announcement.save).to be true
  end

  it "creates an announcement with a user" do
    announcement = create :announcement
    expect(announcement.user_id).not_to be nil
  end

  it "buils and invalid announcement and doesn't save it" do
    announcement = build :announcement, user: nil
    expect(announcement.save).to be false
  end

  it "validates that announcement has a valid title" do
    announcement = build :announcement, title: ""
    expect(announcement.save).to be false
  end

  it "validates that announcement has a valid body" do
    announcement = build :announcement, body: ""
    expect(announcement.save).to be false
  end
end
