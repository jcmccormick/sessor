# Standard User class. Controlled by `devise_token_auth` on the back-end, `ng-token-auth` on the front-end. 
class User < ActiveRecord::Base
	
	include DeviseTokenAuth::Concerns::User
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

	# Include default devise modules.
	devise :omniauthable, :rememberable, :trackable, :validatable

	# def self.from_omniauth(auth)
	# 	where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
	# 		user.provider = auth.provider
	# 		user.uid = auth.uid
	# 		user.email = auth.info.email
	# 		user.password = Devise.friendly_token[0,20]
	# 	end
	# end

end
