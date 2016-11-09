class ChangeColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :gem_gits, :commit_dates, :commit_dates_month
  end
end
