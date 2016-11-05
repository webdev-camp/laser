FactoryGirl.define do
  factory :gem_with_everything do
    sequence :name do |n|
       "ruby_spec#{n}"
     end
    info "SomeInfo"
    current_version "1.2.3"
    current_version_downloads 22
    total_downloads 23
    rubygem_uri "SomeURI"
    documentation_uri "SomeDocURI"
    source_code_uri "source_code_uri"
    homepage_uri "homepage_uri"
    authors "mr tickle"
    laser_gem { create :laser_gem , name: name }
  end
end

