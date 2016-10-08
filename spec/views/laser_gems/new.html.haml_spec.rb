require 'rails_helper'

RSpec.describe "laser_gems/new", type: :view do
  before(:each) do
    assign(:laser_gem, LaserGem.new(
      :name => "MyString"
    ))
  end

  it "renders new laser_gem form" do
    render

    assert_select "form[action=?][method=?]", laser_gems_path, "post" do

      assert_select "input#laser_gem_name[name=?]", "laser_gem[name]"
    end
  end
end
