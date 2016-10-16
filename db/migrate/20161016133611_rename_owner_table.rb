class RenameOwnerTable < ActiveRecord::Migration[5.0]
  def change
    rename_table('owners', 'ownerships')
  end
end
