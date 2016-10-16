class AddDetailsToGemSpecs < ActiveRecord::Migration[5.0]
  def change
    add_column :gem_specs, :source_code_uri, :string
    add_column :gem_specs, :homepage_uri, :string
  end
end
