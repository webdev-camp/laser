require 'yaml'

class TagLoader

  def initialize
    @tags = YAML.load_file('db/tags.yml')
    @gem_loader = GemLoader.new
    @git_loader = GitLoader.new
  end

  def load_tags
    @tags.each do |key, values|
      next if key.length < 3
      puts key.to_s + " tagloader"
      laser_gem = LaserGem.find_or_create_by!(name: key)
      add_tags_to_gem(laser_gem, values)
      @gem_loader.fetch_and_create_gem_spec(laser_gem) unless laser_gem.gem_spec
      @git_loader.fetch_and_create_gem_git(laser_gem)  unless laser_gem.gem_git
    end
  end

private
  def add_tags_to_gem(laser_gem, values)
    return unless laser_gem.tag_list.empty?
    laser_gem.tag_list.add(values.first)
    laser_gem.tag_list.add(values.last)
    laser_gem.save!
  end
end
