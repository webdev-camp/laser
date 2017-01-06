source 'https://rubygems.org'

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'jquery-rails'
gem 'sqlite3'

gem 'sassc-rails'
gem 'haml-rails'

gem 'gems', github: "rubygems/gems"
gem "octokit", "~> 4.0"

gem 'susy'
gem 'breakpoint'
gem 'bootstrap'
gem 'tether-rails'
gem 'simple_form'
gem 'animate-rails'

gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'

gem 'acts-as-taggable-on'
gem 'devise'

gem 'chartkick'
gem "highcharts-rails"
gem "font-awesome-rails"

gem 'jbuilder', '~> 2.5'

gem "therubyracer"

gem 'will_paginate'
gem 'will_paginate-bootstrap4'

gem 'ransack'

gem "sidekiq-cron"

gem "impressionist"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem "capybara"
  gem 'pry-rails'
  gem 'vcr'
  gem "webmock"
end

group :development do
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'puma'
  gem "rb-readline"
end

group :test do
  gem "codeclimate-test-reporter", require: nil
end

gem 'rollbar'
group :production do
  gem "skylight"
  gem "mysql2"
end
