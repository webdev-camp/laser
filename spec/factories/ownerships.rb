FactoryGirl.define do
  factory :ownership do
    sequence :email do |n|
      "ruby#{n}@mail.com"
    end
    owner { create :user }
    gem_spec
    laser_gem
    gem_git
    role "owner"
  end
end
