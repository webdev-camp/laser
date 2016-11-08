RSpec.describe "LaserGemsShow" do

  def add_tag tag
    laser_gem = create :laser_gem
    visit laser_gem_path(laser_gem.name)
    fill_in(:tag , with: tag)
    click_button('save_tag')
  end

  def add_comment comment
    laser_gem = create :laser_gem
    visit laser_gem_path(laser_gem.name)
    fill_in(:comment_body , with: comment)
    click_button('add_comment')
  end

  xit "shows the tag on the page" do
    add_tag "thfsf"
    expect(page).to have_text("thfsf")
  end

  xit "don't add an invalid tag" do
    add_tag "thfsf gem"
    expect(page).to have_text("Please insert a valid tag")
    expect(page).not_to have_content("thfsf gem")
  end

  it "shows the laser gem name" do
    laser_gem = create :laser_gem
    visit laser_gem_path(laser_gem.name)
    expect(page).to have_text(laser_gem.name)
  end

  it "shows the laser gem dependencies" do
    laser_gem = create :laser_gem_with_dependencies
    visit laser_gem_path(laser_gem.name)
    expect(page).to have_text(laser_gem.dependencies.first.name)
  end

  it "shows the laser gem dependents" do
    laser_gem = create :laser_gem_with_dependents
    visit laser_gem_path(laser_gem.name)
    expect(page).to have_text(laser_gem.dependents.first.name)
  end

  it "shows the comment on the page" do
    sign_in_user
    add_comment "I just added this comment"
    expect(page).not_to have_text("CommentError: Please insert a valid comment.")
    expect(page).to have_text("I just added this comment")
  end

  it "adds an invalid comment" do
    sign_in_user
    add_comment "Inv"
    expect(page).to have_text("CommentError: Please insert a valid comment.")
  end

  it "shows the related tags for laser gem" do
    laser_gem = create :laser_gem
    visit laser_gem_path(laser_gem.name)
    expect(page).to have_text(laser_gem.tag_list)
  end

  it "shows the related tags for laser gem" do
    laser_gem = create :laser_gem
    visit laser_gem_path(laser_gem.name)
    expect(page).to have_text(laser_gem.tag_list)
  end
end
