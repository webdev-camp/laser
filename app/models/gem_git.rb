class GemGit < ApplicationRecord
  validates :name, length: {in: 2..62}
  # validates :homepage, presence: true
  validates :last_commit, presence: true
  validates :forks_count, presence: true
  validates :stargazers_count, presence: true
  validates :watchers_count, presence: true
  validates :open_issues_count, presence: true

  belongs_to :laser_gem , required: false
  validates_uniqueness_of :laser_gem_id
end
