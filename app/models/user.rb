class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :name, length: { in: 3..30}, format: { without: /\s/, message: "must contain no spaces" }
  validates :admin, inclusion: { in: [ true, false ] }

  has_many :ownerships , :foreign_key => "owner_id"
  has_many :laser_gems, :through => :ownerships

  has_many :announcements
  has_many :comments

  def connect_ownerships
    Ownership.where(:email => self.email).update_all(owner_id: self.id)
  end
end
