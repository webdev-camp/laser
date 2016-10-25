class Comment < ApplicationRecord
  validates :body, length: { in: 7..300}
  validates :laser_gem_id, presence: true
  validates :user_id, presence: true

  belongs_to :laser_gem
  belongs_to :user
end
