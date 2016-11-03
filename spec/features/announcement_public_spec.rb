
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

  it "goes to log in page when not logged in" do
    visit new_announcement_path
    expect(page).to have_current_path(new_user_session_path)
  end

  it "tells if there are no announcements to show" do
    visit announcements_path
    expect(page).to have_text("No announcements to show")
  end

end
