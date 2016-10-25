class Announcement < ApplicationRecord

  validates :title, length: { in: 2..30}
  validates :body, length: {minimum: 3, maximum: 3000}

  belongs_to :user

end
