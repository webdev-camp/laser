class AddNewColumnToOwner < ActiveRecord::Migration[5.0]
  def change
    add_column :owners, :email, :string
  end
end
