class Ownership < ApplicationRecord
  before_save { self.email = email.downcase if email}
  validates :email, :format => { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create, message:"invalid e-mail"}, :allow_nil => true

  #
  # Note that email presence validation will not work as not all gems have emails for owners
  #
  
  belongs_to :laser_gem
  belongs_to :owner, class_name: User, required: false
  belongs_to :gem_spec, required: false
  belongs_to :gem_git, required: false
end

# rubygem_owner: true or false
# github_owner: true or false
# author: true or false??? (because author name is impossible to connect, so maybe not)

# laser_gem_id
# owner_id (points to user table) - needs a method helper like reg dep to link these up
# gem_spec_id
# gem_git_id
# email
# git_handle
# gem_handle
# rubygem_owner t/f
# github_owner t/f
# github
