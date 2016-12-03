class Category < ApplicationRecord
  validates :name, length: { in: 2..90} 
  has_many :laser_gems
end
