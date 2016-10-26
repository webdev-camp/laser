class AddsBuildDateToGemSpec < ActiveRecord::Migration[5.0]
  def change
    add_column :gem_specs, :build_date, :string
  end
end
