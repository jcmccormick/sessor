class Admin < ActiveRecord::Base
  has_and_belongs_to_many :templates
  has_and_belongs_to_many :reports
  
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User
end
