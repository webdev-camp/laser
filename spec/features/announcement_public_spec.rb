
RSpec.describe "Announcements" do

  it "lists the announcements" do
    visit announcements_path
    expect(page).to have_current_path(announcements_path)
  end

  it "lists items on the page" do
    announcement = create :announcement
    visit announcements_path
    expect(page).to have_text announcement.title
  end

end
