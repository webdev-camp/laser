Warden.test_mode!

RSpec.describe "Tags" do

  before(:each) do
    sign_in_admin
    @laser = create :laser_gem_with_tags
  end

  after(:each) do
    Warden.test_reset!
  end

  def show_path
    tag_path(@laser.tags.first)
  end
  def edit_path
    edit_tag_path(@laser.tags.first)
  end


  it "index works" do
    visit tags_path
    expect(page.status_code).to be 200
  end

  it "index has rows" do
    visit tags_path
    expect(find_all("tr").length).to be >= 1
  end

  it "index hash tag name" do
    visit tags_path
    expect(page).to have_content(@laser.tags.first)
  end

  it "index has tag show link" do
    visit tags_path
    expect(page).to have_link("Show" , href: show_path)
  end

  it "index has tag edit link" do
    visit tags_path
    expect(page).to have_link("Edit" , href: edit_path)
  end

  it "show has tag name" do
    visit show_path
    expect(page).to have_content(@laser.tags.first)
  end

  it "edit has gem name" do
    visit edit_path
    expect(page).to have_content(@laser.tags.first)
  end

  it "edit accept good name" do
    visit edit_path
    fill_in(:'acts_as_taggable_on_tag_name' , with: "tags_ok")
    click_button('Update Tag')
    expect(page).to have_content("tags_ok")
  end

  it "edit rejects bad name" do
    visit edit_path
    fill_in(:'acts_as_taggable_on_tag_name' , with: "tags not ok")
    click_button('Update Tag')
    expect(page).to have_content("Invalid")
  end

  it "new redirects to index" do
    visit new_tag_path
    expect(page).to have_current_path(tags_path)
  end

  it "edit has tag delete link" do
    visit edit_path
    expect(page).to have_link("Destroy" , href: show_path)
  end

  it "delete link doesnt work if there is a gem" do
    visit edit_path
    edit_path = edit_path
    click_link("Destroy")
    expect(page).to have_current_path(tags_path)
    expect(page).not_to have_link("Edit" , href: edit_path)
  end

end
