# INACTIVE: Will provide Group functionality to Users.

class Group < ActiveRecord::Base
  
  # Relate to Users.
  has_many :users, inverse_of: :group
end