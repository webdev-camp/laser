FactoryGirl.define do
  factory :laser_gem do
    sequence :name do |n|
      "Ruby#{n}"
    end
    gem_spec { build :gem_spec , laser_gem_id: self.id }

    factory :laser_gem_with_dependencies do
      after(:create) do |laser_gem, evaluator|
        create_list :gem_dependency, 5, laser_gem: laser_gem
      end
    end
    factory :laser_gem_with_dependents do
      after(:create) do |laser_gem, evaluator|
        create_list :gem_dependency, 5, dependency: laser_gem
      end
    end
    factory :laser_gem_with_gem_git do
      after(:create) do |laser_gem, evaluator|
        create :gem_git, laser_gem: laser_gem
      end
    end
    factory :laser_gem_with_source_code_uri do
      after(:create) do |laser_gem, evaluator|
        create :gem_spec, laser_gem: laser_gem,
          source_code_uri: "http://github.com/rails/rails"
      end
    end

    factory :laser_gem_with_ownership do
      after(:create) do |laser_gem, evaluator|
        create :ownership, laser_gem: laser_gem
      end
    end
  end
end
