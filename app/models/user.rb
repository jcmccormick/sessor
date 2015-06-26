class User < ActiveRecord::Base
  belongs_to :group, inverse_of: :users
  has_and_belongs_to_many :templates
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
