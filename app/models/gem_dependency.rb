class GemDependency < ApplicationRecord
  belongs_to :laser_gem
  belongs_to :dependency, class_name: "LaserGem"
  
  # A LaserGem cannot have the same dependency LaserGem added twice
  # Note that this prevents a gem with the same name being added as a dependency twice EVEN IF the vesion numbers are different.
  # validates_uniqueness_of :laser_gem_id, scope: :dependency_id

  # A GemDependency must have both a LaserGem AND a dependency LaserGem
  validates :laser_gem, :dependency, presence: true

  validates :version, presence: true
end
