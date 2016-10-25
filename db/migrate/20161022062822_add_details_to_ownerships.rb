class AddDetailsToOwnerships < ActiveRecord::Migration[5.0]
  def change
    remove_column :ownerships, :name, :string
    add_column :ownerships, :rubygem_owner, :boolean
    add_column :ownerships, :github_owner, :boolean
    add_column :ownerships, :github_profile, :string
    add_column :ownerships, :git_handle, :string
    add_column :ownerships, :gem_handle, :string
    add_reference :ownerships, :owner, index:true

    add_foreign_key :ownerships, :users, column: :owner

    add_index :ownerships, [ :owner_id, :laser_gem_id ], unique: true
  end
end
