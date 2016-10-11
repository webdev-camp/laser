
RSpec.describe "LaserGems", type: :request do
  it "gets index" do
    get laser_gems_path
    expect(response).to have_http_status(200)
  end

  it "gets show" do
    gem = create :laser_gem
    get show_laser_gem_path gem
    expect(response).to have_http_status(200)
  end

end
