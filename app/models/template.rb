class Template < ActiveRecord::Base
  has_many :reports
  has_and_belongs_to_many :admins
  has_and_belongs_to_many :users
end
