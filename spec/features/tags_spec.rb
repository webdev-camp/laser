Warden.test_mode!

RSpec.describe "Tags" do

  before(:each) do
    sign_in_admin
  end
  after(:each) do
    Warden.test_reset!
  end

  describe "GET /tags" do
    it "works for admins" do
      visit tags_path
      expect(page).to have_current_path(tags_path)
    end
  end
end
