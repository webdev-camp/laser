
RSpec.describe "LaserGems", type: :request do
  describe "GET /laser_gems" do
    it "works! (now write some real specs)" do
      get laser_gems_path
      expect(response).to have_http_status(200)
    end
  end
end
