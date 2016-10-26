class AddAuthorsToGemSpecs < ActiveRecord::Migration[5.0]
  def change
    add_column :gem_specs, :authors, :string
  end
end
