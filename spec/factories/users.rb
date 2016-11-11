FactoryGirl.define do
  factory :user do
    name "MyUsername"
    admin false
    sequence :email do |n|
      "user#{n}@example.com"
    end
    password "slkjlskjsndkdj"
    password_confirmation "slkjlskjsndkdj"
    confirmed_at Time.now
  end
end
