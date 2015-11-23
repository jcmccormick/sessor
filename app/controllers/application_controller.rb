# Author:: Joe McCormick (mailto:joe.c.mccormick@gmail.com)
# Copyright:: Copyright (c) 2015 Joe McCormick
# License:: May not replicate or duplicate in any way.

# The Application Controller includes necessary modules and uses a workaround to define the `current_user`

class ApplicationController < ActionController::Base

	# Protect the site from CSRF
	protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }
	
	# Include depdencies for `clean_pagination`, `devise`, and response types.
	include DeviseTokenAuth::Concerns::SetUserByToken
	include ActionController::MimeResponds

	before_action :configure_permitted_parameters, if: :devise_controller?

	protected

		def current_user
			@current_user ||= User.find_by_id(session[:user_id])
		end

		def signed_in?
			!!current_user
		end

		helper_method :current_user, :signed_in?

		def current_user=(user)
			@current_user = user
			session[:user_id] = user.id
		end

		def configure_permitted_parameters
			devise_parameter_sanitizer.for(:sign_up) << [:name, :nickname]
			devise_parameter_sanitizer.for(:account_update) << [:name, :nickname]
		end

end