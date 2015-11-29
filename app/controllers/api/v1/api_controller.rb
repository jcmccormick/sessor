# API connector Module. Provides version control for the API. Authenticates requesting user.
module Api::V1
	class ApiController < ApplicationController

		before_action :authenticate_user!

		def google_drive
			token = update_access_token
			GoogleDrive.login_with_oauth(token) if current_user
		end

		def update_access_token
			current_user.refresh_google_oauth2_token if token_is_old
			current_user.access_token
		end

		def token_is_old
			Time.at(current_user.expires_at) < Time.now()
		end

	end
end