# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'
require 'yaml'

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


  desc "Scrape tags from Ruby Toolbox with Mechanize"
  task :scraper => :environment do
      agent = Mechanize.new do |a|
        a.user_agent_alias = 'Mac Safari'
      end
      page = agent.get('https://www.ruby-toolbox.com/categories/by_name')
      tag_hash = {}
      (page.search(".link.odd") + page.search(".link.even")).each do |element|
        # creates subcategory keys for tag_hash
        subcategory = element.children.first.text.strip.parameterize.underscore
        # creates the new_tag_array values for tag_hash
        tag_array = element.children[1].children.text.strip.split(",")
        tag_array.pop if tag_array.last.include?("more")
        new_tag_array = tag_array.collect { |tag| tag.parameterize.underscore}
        # creates the tag_hash
        tag_hash[subcategory] = new_tag_array
       end
       f = File.open('db/tags.yml', 'w')
       f.write( tag_hash.to_yaml )
    end
end
