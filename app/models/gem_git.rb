class GemGit < ApplicationRecord
  serialize :commit_dates_month, Array
  serialize :commit_dates_year, Array

  validates :name, length: {in: 2..180}
  # validates :homepage, presence: true
  validates :last_commit, presence: true
  validates :forks_count, presence: true
  validates :stargazers_count, presence: true
  validates :watchers_count, presence: true
  validates :open_issues_count, presence: true

  belongs_to :laser_gem , required: false
  validates_uniqueness_of :laser_gem_id

  # has_many :ownerships
  # has_many :owners, :through => :ownerships, :foreign_key => "gem_git_id", :source => "owner"
end
