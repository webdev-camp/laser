class CreateGemDependencies < ActiveRecord::Migration[5.0]
  def change
    create_table :gem_dependencies do |t|
      t.references :laser_gem, foreign_key: true, index: true
      t.references :dependency, index: true
      t.string :version

      t.timestamps
    end
    add_foreign_key :gem_dependencies, :laser_gems, column: :dependency_id

  # A LaserGem cannot have the same dependency LaserGem added twice
    add_index :gem_dependencies, [ :laser_gem_id, :dependency_id ], unique: true
  end
end
