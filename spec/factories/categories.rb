FactoryGirl.define do
  factory :category do
    sequence :name do |n|
      "Cat#{n}"
    end
  end
end
