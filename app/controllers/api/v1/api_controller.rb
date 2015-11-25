# API connector Module. Provides version control for the API. Authenticates requesting user.
module Api::V1
	class ApiController < ApplicationController

		before_action :authenticate_user!
		
	end
end