class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.timestamps
    end
    add_reference :laser_gems, :category, index:true
    move_tags_to_categories
  end

  def move_tags_to_categories
    # always two tags, higher tagging count becomes category
    puts "Creating categories, wait . . . "
    LaserGem.all.includes(:taggings => :tag).each do |g|
      t = g.tags.sort_by(&:taggings_count).last
      next unless t
      g.category = Category.find_or_create_by name: t.name
      g.save
    end
    Category.all.each do |c|
      t = ActsAsTaggableOn::Tag.includes(:taggings).find_by(name: c.name )
      next unless t
      t.destroy
    end
  end
end
