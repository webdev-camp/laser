FactoryGirl.define do
  factory :announcement do
    title "MyString"
    body "MyText " * 10 
    user
  end
end
