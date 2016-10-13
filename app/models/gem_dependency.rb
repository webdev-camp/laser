class GemDependency < ApplicationRecord
  belongs_to :laser_gem
  belongs_to :dependency, class_name: "LaserGem"
  
  #
  # A LaserGem cannot have itself as a dependency
  #
  validate :not_self_dependent

  def not_self_dependent
    if self.laser_gem_id == self.dependency_id
      errors.add(:dependency, :not_valid, message: "Gem cannot depend upon itself")
    end
  end

  # A LaserGem cannot have the same dependency LaserGem added twice
  # Note that this prevents a gem with the same name being added as a dependency twice 
  # EVEN IF the vesion numbers are different.
  # validates_uniqueness_of :laser_gem_id, scope: :dependency_id

  # A GemDependency must have both a LaserGem AND a dependency LaserGem
  validates :laser_gem, :dependency, presence: true

  validates :version, presence: true
end
