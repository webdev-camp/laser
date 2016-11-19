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

  desc "Load tags for Gems"
  task :load_tags => :environment do
    loader = DataLoader.new
    loader.load_tags
  end

  desc "Load commits per week in last year"
  task :load_commits  => :environment do
    loader = GitLoader.new
    loader.fetch_commits_for_all
  end

  desc "Load rankings"
  task :load_rank  => :environment do
    LaserGem.all.each do |laser_gem|
      Ranking.new(laser_gem).total_rank_calc
      Ranking.new(laser_gem).download_rank_string_calc
      Ranking.new(laser_gem).download_rank_percent_calc
    end
  end

  namespace :fixtures do
    desc 'Dumps all models into fixtures.'
    task :dump => :environment do
      models = [Announcement , Comment , GemDependency , GemGit ,GemSpec, LaserGem ,
                Ownership , ActsAsTaggableOn::Tagging , ActsAsTaggableOn::Tag ,User  ]
      # specify FIXTURES_PATH to test/fixtures if you do test:unit
      dump_dir = "test/fixtures"
      puts "Found models: " + models.join(', ')
      puts "Dumping to: " + dump_dir
      models.each do |model|
        entries = model.unscoped.all.order('id ASC')
        m = model.name.split("::").last.underscore.pluralize
        puts "Dumping model: #{model} (#{entries.length} entries)"
        model_file = Rails.root.join(dump_dir , m + '.yml')
        output = {}
        entries.each do |a|
          attrs = a.attributes
          attrs.delete_if{|k,v| v.nil?}
          output["#{m}_#{a.id}"] = attrs
        end
        file = File.open(model_file, 'w')
        file << output.to_yaml
        file.close #better than relying on gc
      end
    end
  end

end
