class CreateAnnouncements < ActiveRecord::Migration[5.0]
  def change
    create_table :announcements do |t|
      t.string :title
      t.text :body

      t.timestamps
      t.belongs_to :user
    end
  end
end
