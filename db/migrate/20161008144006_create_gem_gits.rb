class CreateGemGits < ActiveRecord::Migration[5.0]
  def change
    create_table :gem_gits do |t|
      t.string :name
      t.string :homepage
      t.date :last_commit
      t.integer :forks_count
      t.integer :stargazers_count
      t.integer :watchers_count
      t.integer :open_issues_count

      t.timestamps
    end
  end
end
