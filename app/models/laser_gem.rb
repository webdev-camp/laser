class LaserGem < ApplicationRecord
  validates :name, length: { in: 2..30}, format: { without: /\s/, message: "must contain no spaces" }

  has_many :gem_dependencies
  has_many :dependencies, :through => :gem_dependencies

  has_many :gem_dependents, class_name: "GemDependency", foreign_key: :dependency_id
  has_many :dependents, :through => :gem_dependents, source: :laser_gem

  has_one :gem_git 

  #
  # Add a gem as a dependency of this one.
  #
  def register_dependency(dep, version)
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
