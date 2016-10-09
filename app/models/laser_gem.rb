class LaserGem < ApplicationRecord
  has_many :gem_dependencies

  #
  # Add a gem as a dependency of this one.
  #
  def register_dependency(dep, version:)
    GemDependency.create!(
      laser_gem: self,
      dependency: dep,
      version: version,
    )
    self.reload
  end

  #
  # Remove a dependency
  #
  def remove_dependency(dep)
    GemDependency.destroy_all(
      laser_gem: self,
      dependency: dep,
    )
    self.reload
  end
end
