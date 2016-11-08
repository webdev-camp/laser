class Announcement < ApplicationRecord

  validates :title, length: { in: 5..30}, presence: true
  validates :body, length: {minimum: 10, maximum: 3000}, presence: true

  belongs_to :user , required: true

end
