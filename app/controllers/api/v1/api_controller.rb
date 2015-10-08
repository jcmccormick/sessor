# API connector Module. Provides version control for the API.

module Api::V1

	# Standard API Controller authenticates requesting user.
	class ApiController < ApplicationController
		before_action :authenticate_user!
	end
end