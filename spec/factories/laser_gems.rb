FactoryGirl.define do
  factory :laser_gems do
    sequence :name do |n|
       "Ruby#{n}"
     end
  end

end
