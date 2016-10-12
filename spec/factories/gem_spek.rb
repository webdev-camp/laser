FactoryGirl.define do
  factory :gem_spec do
    sequence :name do |n|
       "RubySpec#{n}"
     end
    info "SomeInfo"
    current_version "1.2.3"
    current_version_downloads 22
    total_downloads 23
    rubygem_uri "SomeURI"
    documentation_uri "SomeDocURI"

    factory :gem_spec_with_laser_gem do
      laser_gem
    end
  end

end
