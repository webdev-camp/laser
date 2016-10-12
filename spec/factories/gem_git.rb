FactoryGirl.define do
  factory :gem_git do
    sequence :name do |n|
       "RubyGit#{n}"
     end
     homepage "SomeHomepage"
     last_commit 2001-02-03
     forks_count 6
     stargazers_count 6
     watchers_count 6
     open_issues_count 6
  end
end
