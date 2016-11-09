class AddCommitDatesToGemGits < ActiveRecord::Migration[5.0]
  def change
    add_column :gem_gits, :commit_dates, :text
  end
end
