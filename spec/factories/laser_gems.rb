FactoryGirl.define do
  factory :laser_gem do
    sequence :name do |n|
       "Ruby#{n}"
     end
  end

end
