# Standard User class. Controlled by `devise_token_auth` on the back-end, `ng-token-auth` on the front-end. 

class User < ActiveRecord::Base
  has_many :authorizations

  # Relate to Group.
  belongs_to :group

  # Relate to Templates.
  has_and_belongs_to_many :templates

  # Relate to Reports.
  has_and_belongs_to_many :reports

  # Relate to Fields
  has_many :fields, through: :templates

  # Relate to Values
  has_many :values, through: :reports


  # Before saving set UID to a Universial Unique ID, and skip e-mail confirmation.
  before_save -> do
    self.uid = SecureRandom.uuid
    skip_confirmation!
  end

  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User
  
  def self.create_from_hash!(hash)
    create(:name => hash['user_info']['name'])
  end
end
