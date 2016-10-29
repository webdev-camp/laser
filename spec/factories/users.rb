FactoryGirl.define do
  factory :user do
    name "MyUsername"
    sequence :email do |n|
      "user#{n}@example.com"
    end
    password "slkjlskjsndkdj"
  end
end
