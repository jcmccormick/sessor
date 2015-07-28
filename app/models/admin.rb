# INACTIVE: Will provide an Admin User class.

class Admin < ActiveRecord::Base

  # Relate to Templates.
  has_and_belongs_to_many :templates

  # Relate to Reports.
  has_and_belongs_to_many :reports
  
  # Include default `devise` modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User
end
