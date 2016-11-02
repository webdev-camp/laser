
RSpec.describe "LaserGems" do
  it "gets index" do
    visit laser_gems_path
    expect(page.status_code).to be 200
  end

  it "index with item works" do
    gem = create :laser_gem
    create :gem_spec, laser_gem_id: gem.id
    visit laser_gems_path
    expect(page.status_code).to be 200
  end

  it "show for item works" do
    gem = create :laser_gem
    create :gem_spec, laser_gem_id: gem.id
    visit laser_gems_path
    click_link gem.name
    expect(page.status_code).to be 200
  end
end
