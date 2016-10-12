class AddLaserGemIdToGemSpec < ActiveRecord::Migration[5.0]
  def change
    add_column :gem_specs, :laser_gem_id, :integer
  end
end
