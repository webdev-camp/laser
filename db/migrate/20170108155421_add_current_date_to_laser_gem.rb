class AddCurrentDateToLaserGem < ActiveRecord::Migration[5.0]
  def change
    add_column    :gem_specs, :current_version_creation, :date

    add_column    :ownerships, :github_id, :integer
    remove_column :ownerships, :rubygem_owner, :boolean
    remove_column :ownerships, :github_owner, :boolean
    remove_column :ownerships, :github_profile, :string
  end
end
