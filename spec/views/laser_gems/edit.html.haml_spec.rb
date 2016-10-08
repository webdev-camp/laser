require 'rails_helper'

RSpec.describe "laser_gems/edit", type: :view do
  before(:each) do
    @laser_gem = assign(:laser_gem, LaserGem.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit laser_gem form" do
    render

    assert_select "form[action=?][method=?]", laser_gem_path(@laser_gem), "post" do

      assert_select "input#laser_gem_name[name=?]", "laser_gem[name]"
    end
  end
end
