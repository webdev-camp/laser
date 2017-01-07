
RSpec.describe "Updates" , :vcr do

  it "shows update page to anyone" do
    visit updates_show_path
    expect(page).to have_current_path(updates_show_path)
    expect(page).to have_text( "update a gem")
  end

  it "invalid name return to same page" do
    visit updates_show_path
    fill_in(:'gem_name' , with: "something")
    click_button('Update Gem')
    expect(page).to have_current_path(updates_show_path)
    expect(page).to have_text( "does not appear to be a valid gem")
  end

  it "valid name enques a job" do
    visit updates_show_path
    fill_in(:'gem_name' , with: "bootstrap")
    expect {
      click_button('Update Gem')
    }.to have_enqueued_job.with("bootstrap")
  end

  it "valid name that did not exits bounces" do
    visit updates_show_path
    fill_in(:'gem_name' , with: "rails")
    page.driver.options[:redirect_limit] = 2
    expect {click_button('Update Gem')}.to raise_exception(Capybara::InfiniteRedirectError)
    expect(page).to have_current_path(updates_bounce_path("rails" , count: 1))
  end

  it "valid name that did exits back to gems page" do
    UpdateLaserGemJob.perform_now("rails")
    visit updates_show_path
    fill_in(:'gem_name' , with: "rails")
    click_button('Update Gem')
    expect(page).to have_current_path(laser_gem_path("rails"))
    expect(page).to have_text( "rails")
  end

  it 'bounces from bounce to laser_gem_path if the gem exists' do
    UpdateLaserGemJob.perform_now("rails")
    visit updates_bounce_path("rails")
    expect(page).to have_current_path(laser_gem_path("rails"))
    expect(page).to have_text( "rails")
  end

  it 'bounces at least twice if the gem did not exists' do
    expect {visit updates_bounce_path("rails")}.to raise_exception(Capybara::InfiniteRedirectError)
    expect(page).to have_current_path(updates_bounce_path("rails" , count: 2))
  end

  it 'bounces no more than 4 times if gem did not exists' do
    page.driver.options[:redirect_limit] = 4
    visit updates_bounce_path("rails")
    expect(page).to have_current_path(laser_gems_path)
  end
end
