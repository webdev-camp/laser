RSpec.describe "Announcements" do

  def add_announcement announcement
    visit new_announcement_path
    fill_in(:'announcement_title' , with: title)
    fill_in(:'announcement_body' , with: announcement)
    click_button('Save')
  end

    it "adds announcement" do
    add_announcement "MyAnnouncement body goes here"
    expect(page.status_code).to be 200
  end

  it "shows the announcement on the page" do
    add_announcement "I just added this announcement"
    expect(page).not_to have_text("error")
    expect(page).to have_text("I just added this announcement")
  end

  it "adds an invalid announcement" do
    add_announcement ""
    expect(page).to have_text("error")
  end

end
