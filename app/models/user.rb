# Standard User class. Controlled by `devise_token_auth` on the back-end, `ng-token-auth` on the front-end. 
class User < ActiveRecord::Base
    
    # Include default devise modules.
    include DeviseTokenAuth::Concerns::User
    devise :omniauthable, :rememberable, :trackable, :validatable, :omniauth_providers => [:google_oauth2]

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

    def refresh_google_oauth2_token
        oauth_client = OAuth2::Client.new(
            ENV['GOOGLE_CLIENT_ID'],
            ENV['GOOGLE_CLIENT_SECRET'],
            :site => "https://accounts.google.com",
            :token_url => "/o/oauth2/token",
            :authorize_url => "/o/oauth2/auth",
            :ssl => {:verify => !Rails.env.development?}
        )
        puts self.refresh_token
        access_token = OAuth2::AccessToken.from_hash(oauth_client, {:refresh_token => self.refresh_token})
        access_token = access_token.refresh!
        self.access_token = access_token.token
        self.expires_at = Time.now + access_token.expires_in
        self.save
    end

    def token_is_old
        Time.at(self.expires_at) < Time.now()
    end

end
