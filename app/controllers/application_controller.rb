# The application is a Reporting system. HTML forms are saved as a Template object (themselves containing Sections, Columns, Fields, Values, and Options). Templates are used as a single page of a Report object. New Reports duplicate its Templates' Values, as to allow for default Template Values, and unique Report Values. Statistics, Groups, Schedules, and Appointments provide small-business functionalities.

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

		def configure_permitted_parameters
			devise_parameter_sanitizer.for(:sign_up) << :nickname
			devise_parameter_sanitizer.for(:account_update) << [:name, :nickname]
		end

end