
RSpec.describe "Static pages" do

  it "renders contribute" do
    visit contribute_path
    expect(page).to have_current_path(contribute_path)
    expect(page.status_code).to be 200
  end


end
