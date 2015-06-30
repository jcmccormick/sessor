class Report < ActiveRecord::Base
  belongs_to :template
  has_and_belongs_to_many :admins
  has_and_belongs_to_many :users
end