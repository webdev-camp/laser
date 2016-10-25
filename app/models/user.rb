class User < ApplicationRecord
  validates :name, length: { in: 3..30}, format: { without: /\s/, message: "must contain no spaces" }

  has_many :announcements
end
