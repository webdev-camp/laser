RSpec.describe "Announcements" do

  def add_announcement announcement, title
    visit new_announcement_path
    fill_in(:'announcement_title' , with: title)
    fill_in(:'announcement_body' , with: announcement)
    click_button('Save')
  end

  it "adds announcement" do
    add_announcement "MyAnnouncement body goes here", "title"
    expect(page.status_code).to be 200
  end

  it "shows the announcement on the page" do
    add_announcement "I just added this announcement", "title"
    expect(page).not_to have_text("error")
    expect(page).to have_text("I just added this announcement")
  end

  it "adds an invalid announcement" do
    add_announcement "" , ""
    expect(page).to have_text("error")
  end

  it "checks that the announcement's title is edited" do
    announcement = build :announcement, title: "title"
    announcement.title = "new_title"
    expect(announcement.title).to eq "new_title"
  end

  it "checks that the announcement's body is edited" do
    announcement = build :announcement, body: "announcement body", title: "title"
    announcement.body = "new announcement body"
    expect(announcement.body).to eq "new announcement body"
  end

  it "checks that user is not able to add announcement with empty title" do
    announcement = build :announcement, title: ""
    expect(announcement.save).to be false
  end

  it "checks that user is not able to add announcement with empty body" do
    announcement = build :announcement, body: ""
    expect(announcement.save).to be false
  end
end
