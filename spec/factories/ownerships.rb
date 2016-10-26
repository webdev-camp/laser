FactoryGirl.define do
  factory :ownership do
    sequence :email do |n|
      "ruby#{n}@mail.com"
    end
    owner { create :user }
    laser_gem
  end
end
