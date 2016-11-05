
RSpec.describe "LaserGems" do
  def create_gem
    gem = create :laser_gem
    create :gem_spec, laser_gem_id: gem.id
    visit laser_gems_path
  end

  it "gets index" do
    visit laser_gems_path
    expect(page.status_code).to be 200
  end

  it "index with item works" do
    create_gem
    expect(page.status_code).to be 200
  end

  it "show for item works" do
    gem = create :laser_gem
    create :gem_spec, laser_gem_id: gem.id
    visit laser_gems_path
    click_link gem.name
    expect(page.status_code).to be 200
  end

  it "shows the related tags for laser gem" do
    laser_gem = create :laser_gem_with_spec
    visit laser_gems_path
    expect(page).to have_text(laser_gem.tag_list)
  end
end
