require 'yaml'

class TagLoader

  def initialize
    @tags = YAML.load_file('db/tags.yml')
  end

  def load_tags
    @tags.each do |key, values|
      laser_gem = LaserGem.find_or_create_by! (name: key)
      laser_gem.tag_list.add(values.first)
      laser_gem.tag_list.add(values.last)
      laser_gem.save!
    end
  end
end
