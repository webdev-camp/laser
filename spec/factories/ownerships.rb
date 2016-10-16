FactoryGirl.define do
  factory :ownership do
    name "MyString"
    email "alice@dee.com"
    laser_gem { create :laser_gem }
  end
end
