# API connector Module. Provides version control for the API.

module Api::V1

	# Standard API Controller authenticates requesting user.
	class ApiController < ApplicationController
		devise_token_auth_group :member, contains: [:user, :admin]
		before_action :authenticate_member!
	end
end