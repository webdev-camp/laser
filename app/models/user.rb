class User < ApplicationRecord
  validates :name, length: { in: 3..30}, format: { without: /\s/, message: "must contain no spaces" }

  has_many :owners, :class_name => User
  has_many :ownerships
  has_many :laser_gems, :through => :ownerships
end
