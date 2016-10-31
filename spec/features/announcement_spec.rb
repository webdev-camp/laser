Warden.test_mode!

RSpec.describe "Announcements" do

  def add_announcement announcement, title
    visit new_announcement_path
    fill_in(:'announcement_title' , with: title)
    fill_in(:'announcement_body' , with: announcement)
    click_button('Save')
  end

  def edit_announcement body, title
    new_announcement = create :announcement
    visit edit_announcement_path(new_announcement)
    fill_in(:'announcement_title' , with: title) if title
    fill_in(:'announcement_body' , with: body) if body
    click_button('Save')
    new_announcement
  end

  before(:each) do
    sign_in_user
  end

  after(:each) do
    Warden.test_reset!
  end

  it "goes to new page as logged in user" do
    visit new_announcement_path
    expect(page).to have_current_path(new_announcement_path)
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
    edit_announcement nil, "edited_title"
    expect(page).to have_text "edited_title"
  end

  it "checks that the announcement's body is edited" do
    edit_announcement "edited_body", nil
    expect(page).to have_text "edited_body"
  end

  it "checks that user is not able to add announcement with empty body" do
    edit_announcement "xyzz", nil
    expect(page).to have_text "error"
  end

  it "checks that user is not able to add announcement with empty title" do
    edit_announcement nil, "xxyz"
    expect(page).to have_text "error"
  end
end
