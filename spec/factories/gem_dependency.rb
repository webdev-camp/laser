FactoryGirl.define do
  factory :gem_dependency do
    laser_gem
    dependency { create :laser_gem }
    version "1.0.1"
  end
end
