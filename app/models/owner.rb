class Owner < ApplicationRecord
  validates :name, length: { in: 3..30}, format: { without: /\s/, message: "must contain no spaces" }
end
