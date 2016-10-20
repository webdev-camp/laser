# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

namespace :laser do
  desc "Load Gem, spec, github data and recurse for dependencies"
  task :load_gem => :environment do
    loader = GemLoader.new
    rails_laser_gem = LaserGem.create!(name: "rails")
    loader.fetch_and_create_gem_spec(rails_laser_gem)
    # Gets Github data for Gems which have a source_code_uri
    loader2 = GitLoader.new
    loader2.fetch_and_create_gem_git(rails_laser_gem)
  end
  desc "Load spec for Gem and dependencies"
  task :load_spec => :environment do
    loader = GemLoader.new
    rails_laser_gem = LaserGem.create!(name: "rails")
    loader.fetch_and_create_gem_spec(rails_laser_gem)
  end
  desc "Load Github data for existing database Gems and deps"
  task :load_git => :environment do
    # Gets Github data for Gems which have a source_code_uri
    rails_laser_gem = LaserGem.find_by(name: "rails")
    loader = GitLoader.new
    loader.fetch_and_create_gem_git(rails_laser_gem)
  end
end
