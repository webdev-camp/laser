class AddCommitDatesYearToGemGits < ActiveRecord::Migration[5.0]
  def change
    add_column :gem_gits, :commit_dates_year, :text
  end
end
