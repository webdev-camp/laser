class AddBugTrackerUriToGemSpec < ActiveRecord::Migration[5.0]
  def change
    add_column :gem_specs, :bug_tracker_uri, :string
  end
end
