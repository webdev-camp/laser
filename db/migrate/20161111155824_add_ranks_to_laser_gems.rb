class AddRanksToLaserGems < ActiveRecord::Migration[5.0]
  def change
    add_column :laser_gems, :total_rank, :float
    add_column :laser_gems, :download_rank_percent, :float
    add_column :laser_gems, :download_rank_string, :string
    add_index :laser_gems, :total_rank
  end
end
