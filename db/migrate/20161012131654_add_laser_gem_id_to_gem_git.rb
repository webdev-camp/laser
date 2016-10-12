class AddLaserGemIdToGemGit < ActiveRecord::Migration[5.0]
  def change
    add_column :gem_gits, :laser_gem_id, :integer
  end
end
