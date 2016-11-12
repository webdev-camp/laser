class RemoveCommitDatesMonthFromGemGits < ActiveRecord::Migration[5.0]
  def change
    remove_column :gem_gits, :commit_dates_month, :text
  end
end
