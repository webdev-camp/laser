class AddReferencesToOwners < ActiveRecord::Migration[5.0]
  def change
    add_reference :owners, :laser_gem, foreign_key: true
  end
end
