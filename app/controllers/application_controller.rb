# The application is a Reporting system. HTML forms are saved as a Template object (themselves containing Sections, Columns, Fields, Values, and Options). Templates are used as a single page of a Report object. New Reports duplicate its Templates' Values, as to allow for default Template Values, and unique Report Values. Statistics, Groups, Schedules, and Appointments provide small-business functionalities.

# Author:: Joe McCormick (mailto:joe.c.mccormick@gmail.com)
# Copyright:: Copyright (c) 2015 Joe McCormick
# License:: May not replicate or duplicate in any way.

# The Application Controller includes necessary modules and uses a workaround to define the `current_user`

class ApplicationController < ActionController::Base

	# Protect the site from CSRF
	protect_from_forgery with: :null_session
	
	# Include depdencies for `clean_pagination`, `devise`, and response types.
	include CleanPagination
	include DeviseTokenAuth::Concerns::SetUserByToken
	include ActionController::MimeResponds
	
	# Return empty object is User is unauthorized
	def authenticate_current_user
		render json: {}, status: :unauthorized if get_current_user.nil?
	end

	# Return the User object after attempting to authenticate.
	def get_current_user

		# Set `auth_headers` from request or return nil.
		return nil unless cookies[:auth_headers]
		auth_headers = JSON.parse cookies[:auth_headers]

		# Set paramters for authentication test.
		expiration_datetime = DateTime.strptime(auth_headers["expiry"], "%s")
		current_user = User.find_by uid: auth_headers["uid"]

		# Test whether or not the User's most recent token matches the token sent in `auth_headers`, and that the token is not expired.
		if current_user &&
			 current_user.tokens.has_key?(auth_headers["client"]) &&
			 expiration_datetime > DateTime.now

			@current_user = current_user
		end

		# Return the User object
		@current_user
	end

end