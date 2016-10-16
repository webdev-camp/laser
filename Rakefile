# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

namespace :laser do
  desc "Load Gem and dependencies"
  task :load_gem => :environment do
    loader = GemLoader.new
    rails_laser_gem = LaserGem.create!(name: "rails")
    loader.populate_data(rails_laser_gem)
  end
end
