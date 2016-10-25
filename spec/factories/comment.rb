FactoryGirl.define do
  factory :comment do
    body "Lorem Ipsum has been the industry's standard dummy text ever since"
    laser_gem { create :laser_gem }
    user { create :user}
  end
end
