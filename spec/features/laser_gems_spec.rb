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

  it "index without gem_spec" do
    create :laser_gem
    LaserGem.create!(name: "gems")
    visit laser_gems_path
    expect(page.status_code).to be 200
  end

  it "index with invalid page" do
    create :laser_gem
    LaserGem.create!(name: "gems")
    visit laser_gems_path(page: "-1")
    expect(page.status_code).to be 200
    visit laser_gems_path(page: "200'")
    expect(page.status_code).to be 200
  end

  it "index with item and git works" do
    create :laser_gem_with_gem_git
    visit laser_gems_path
    expect(page.status_code).to be 200
  end

  it "redirects for legacy url" do
    visit "/laser_gems"
    expect(page.status_code).to be 200
    expect(page).to have_current_path(laser_gems_path)
  end

  it "show for item works" do
    gem = create :laser_gem
    visit laser_gems_path
    within('.results') do
      click_link gem.name
    end
    expect(page.status_code).to be 200
  end

  it "searches for gems from index page" do
    laser_gem = create :laser_gem
    create :laser_gem
    visit laser_gems_path
    page.fill_in 'q_gem_spec_name_or_gem_spec_info_cont', :with => laser_gem.gem_spec.name
    click_button "Search"
    expect(page.status_code).to be 200
    gem_elements = page.find_all('.gem_element')
    expect(gem_elements.length).to eq 1
  end

  it "searches for gems from home page" do
    laser_gem = create :laser_gem
    create :laser_gem
    visit root_path
    page.fill_in 'q_gem_spec_name_or_gem_spec_info_cont', :with => laser_gem.gem_spec.name
    click_button "Search"
    expect(page.status_code).to be 200
    gem_elements = page.find_all('.gem_element')
    expect(gem_elements.length).to eq 1
  end

  it "searches for non-existent gems" do
    laser_gem = create :laser_gem
    create :laser_gem
    visit laser_gems_path
    page.fill_in 'q_gem_spec_name_or_gem_spec_info_cont', :with => laser_gem.name+'akjsdhgkjasd'
    click_button "Search"
    expect(page.status_code).to be 200
    gem_elements = page.find_all('.gem_element')
    expect(gem_elements.length).to be 0
  end

  it "searches a part of a gem name" do
    laser_gem = create :laser_gem
    create :laser_gem
    visit laser_gems_path
    page.fill_in 'q_gem_spec_name_or_gem_spec_info_cont', :with => laser_gem.name[0,2]
    click_button "Search"
    expect(page.status_code).to be 200
    gem_elements = page.find_all('.gem_element')
    expect(gem_elements.length).to be > 1
  end

  it "shows the related tags for laser gem" do
    laser_gem = create :laser_gem
    visit laser_gems_path
    expect(page).to have_text(laser_gem.tag_list)
  end

  it "searches for tags" do
    create :laser_gem_with_tags
    visit laser_gems_path
    page.fill_in 'q_taggings_tag_name_eq', :with => 'tag'
    click_button "Search"
    expect(page.status_code).to be 200
    gem_elements = page.find_all('.gem_element')
    expect(gem_elements.length).to be 1
  end

  it "searches for non-existent tags" do
    create :laser_gem_with_tags
    visit laser_gems_path
    page.fill_in 'q_taggings_tag_name_eq', :with => 'tag' + 'akjsdhgkjasd'
    page.find('button[type="submit"]').click
    expect(page.status_code).to be 200
    gem_elements = page.find_all('.gem_element')
    expect(gem_elements.length).to be 0
  end

  it "not searches for a part of a tag" do
    create :laser_gem_with_tags
    visit laser_gems_path
    page.fill_in 'q_taggings_tag_name_eq', :with => 'tag'[0,2]
    page.find('button[type="submit"]').click
    expect(page.status_code).to be 200
    gem_elements = page.find_all('.gem_element')
    expect(gem_elements.length).to be 0
  end
end
