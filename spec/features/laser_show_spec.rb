RSpec.describe "LaserGemsShow" do

  def add_tag tag
    laser_gem = create :laser_gem_with_spec
    visit laser_gem_path(laser_gem.name)
    fill_in(:tag , with: tag)
    click_button('save_tag')
  end

  it "adds tag" do
    add_tag "rails"
    expect(page.status_code).to be 200
  end

  it "shows the tag on the page" do
    add_tag "thfsf"
    expect(page).to have_text("thfsf")
  end

  it "don't add an invalid tag" do
    add_tag "thfsf gem"
    expect(page).to have_text("Please insert a valid tag")
    expect(page).not_to have_content("thfsf gem")
  end

  it "shows the laser gem name" do
    laser_gem = create :laser_gem_with_spec
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
end
