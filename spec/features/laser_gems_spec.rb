RSpec.describe "LaserGems" do
  it "gets index" do
    visit laser_gems_path
    expect(page.status_code).to be 200
  end

  it "index with item works" do
    create :laser_gem
    visit laser_gems_path
    expect(page.status_code).to be 200
  end

  it "show for item works" do
    gem = create :laser_gem
    visit laser_gems_path
    click_link gem.name
    expect(page.status_code).to be 200
  end

  it "searches for gems" do
    laser_gem = create :laser_gem
    create :laser_gem
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

  it "searches for non-existent gems" do
    laser_gem = create :laser_gem
    create :laser_gem
    visit laser_gems_path
    page.fill_in 'q_name_cont', :with => laser_gem.name+'akjsdhgkjasd'
    page.find('input[name="commit"]').click
    expect(page.status_code).to be 200
    gem_elements = page.find_all('.gem_element')
    expect(gem_elements.length).to be 0
  end

  it "searches a part of a gem name" do
    laser_gem = create :laser_gem
    create :laser_gem
    visit laser_gems_path
      page.fill_in 'q_name_cont', :with => laser_gem.name[0,2]
    page.find('input[name="commit"]').click
    expect(page.status_code).to be 200
    gem_elements = page.find_all('.gem_element')
    expect(gem_elements.length).to be >= 1
  end

  it "shows the related tags for laser gem" do
    laser_gem = create :laser_gem
    visit laser_gems_path
    expect(page).to have_text(laser_gem.tag_list)
  end
end
