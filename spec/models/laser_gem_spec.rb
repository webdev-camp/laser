require 'rails_helper'

RSpec.describe LaserGem, type: :model do
  it "has working factory" do
    laser_gem = build :laser_gem
    expect(laser_gem.save).to be true
  end

  it "checks name attribute" do
    laser_gem = build :laser_gem, name: ""
    expect(laser_gem.save).to be false
  end

  it "validates low values for length" do
    laser_gem = build :laser_gem, name: "t"
    expect(laser_gem.save).to be false
  end

  it "validates high values for length" do
    laser_gem = build :laser_gem, name: "hstglsnfmndvbdkjsdkfjdvjdfjdvkdjkkdjfkj"
    expect(laser_gem.save).to be false
  end
end
