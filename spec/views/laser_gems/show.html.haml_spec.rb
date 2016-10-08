require 'rails_helper'

RSpec.describe "laser_gems/show", type: :view do
  before(:each) do
    @laser_gem = assign(:laser_gem, LaserGem.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
