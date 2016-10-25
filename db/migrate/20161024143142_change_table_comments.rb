class ChangeTableComments < ActiveRecord::Migration[5.0]
  def change
   change_table :comments do |t|
      t.remove :name
      t.text :body
    end
  end
end
