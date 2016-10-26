class GemSpec < ApplicationRecord

  validates :name, length: { in: 2..30}
  validates :info, presence: true
  validates :current_version, presence: true
  validates :current_version_downloads, presence: true
  validates :total_downloads, presence: true
  validates :rubygem_uri, presence: true

  belongs_to :laser_gem
  validates_uniqueness_of :laser_gem_id

end
