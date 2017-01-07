# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'
require 'yaml'
require "gem_loader"
require "git_loader"

Rails.application.load_tasks

namespace :laser do
  desc "Load Gem, spec, github data and recurse for dependencies"
  task :load_rails => :environment do
    rails_laser_gem = GemLoader.new.create_or_update_spec("rails")
    # Gets Github data for Gems which have a source_code_uri
    GitLoader.new.fetch_and_create_gem_git(rails_laser_gem)
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
