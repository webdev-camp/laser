
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

  it "searches for gem stuff " do
    laser_gem = create :laser_gem_with_spec
    create :laser_gem_with_spec
    visit laser_gems_path
    # find and set the search input
    page.fill_in 'q_name_cont', :with => laser_gem.name
    # click the search button
    page.find('input[name="commit"]').click
    expect(page.status_code).to be 200
    # check that there are some results
    gem_elements = page.find_all('.gem_element')
    expect(gem_elements.length).to be 1
  end
end
