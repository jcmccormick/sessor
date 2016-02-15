# Standard User class. Controlled by `devise_token_auth` on the back-end, `ng-token-auth` on the front-end. 
class User < ActiveRecord::Base
    
    # Include default devise modules.
    devise :omniauthable, :omniauth_providers => [:google_oauth2, :github, :facebook]
    
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

end
