class Announcement < ApplicationRecord

  validates :title, length: { in: 5..30}
  validates :body, length: {minimum: 10, maximum: 3000}

  belongs_to :user

end
