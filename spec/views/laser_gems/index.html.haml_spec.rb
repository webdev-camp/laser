
RSpec.describe "laser_gems/index", type: :view do
  before(:each) do
    assign(:laser_gems, [
      LaserGem.create!(
        :name => "Name"
      ),
      LaserGem.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of laser_gems" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
