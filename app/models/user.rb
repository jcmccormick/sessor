class User < ActiveRecord::Base
  has_and_belongs_to_many :reports
  
  # Include default devise modules.
  before_save -> do
    self.uid = SecureRandom.uuid
    skip_confirmation!
  end
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User
end
