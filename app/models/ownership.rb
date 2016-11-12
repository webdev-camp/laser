class Ownership < ApplicationRecord
  before_save { self.email = email.downcase if email}
  validates :email, :format => { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create, message:"invalid e-mail"}, :allow_nil => true

  #
  # Note that email presence validation will not work as not all gems have emails for owners
  #
  #

  belongs_to :laser_gem
  belongs_to :owner, class_name: User, required: false
  belongs_to :gem_spec, required: false
  belongs_to :gem_git, required: false

end
