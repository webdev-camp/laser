class Owner < ApplicationRecord
  validates :name, length: { in: 3..30}, format: { without: /\s/, message: "must contain no spaces" }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create, message:"invalid e-mail" }
end
