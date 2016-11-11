class GemSpec < ApplicationRecord

  validates :name, length: { in: 2..90}
  validates :info, presence: true
  validates :current_version, presence: true
  validates :current_version_downloads, presence: true
  validates :total_downloads, presence: true
  validates :rubygem_uri, presence: true

  belongs_to :laser_gem
  validates_uniqueness_of :laser_gem_id


  def home_page
    return self.source_code_uri unless self.source_code_uri.blank?
    homepage_uri
  end
end
