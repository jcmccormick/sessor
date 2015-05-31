class User < ActiveRecord::Base
  # Include default devise modules.
  before_save -> do
    skip_confirmation!
  end
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User
end
