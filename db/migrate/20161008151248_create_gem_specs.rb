class CreateGemSpecs < ActiveRecord::Migration[5.0]
  def change
    create_table :gem_specs do |t|
      t.string :name
      t.text :info
      t.string :current_version
      t.integer :current_version_downloads
      t.integer :total_downloads
      t.string :rubygem_uri
      t.string :documentation_uri

      t.timestamps
    end
  end
end
