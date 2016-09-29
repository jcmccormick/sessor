# Author:: Joe McCormick (mailto:joe.c.mccormick@gmail.com)
# Copyright:: Copyright (c) 2015 Joe McCormick
# License:: May not replicate or duplicate in any way.

# The Application Controller includes necessary modules and uses a workaround to define the `current_user`

class ApplicationController < ActionController::Base
    # force_ssl if !Rails.env.development?

    respond_to :json

    # Protect the site from CSRF
    protect_from_forgery

    before_filter :configure_permitted_parameters, if: :devise_controller?

    after_filter :set_csrf_cookie_for_ng

    include DeviseTokenAuth::Concerns::SetUserByToken

    def set_csrf_cookie_for_ng
      cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
    end

    def new_session_path(scope)
        new_user_session_path
    end

    protected

    def verified_request?
        super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
    end

    def configure_permitted_parameters
        Rails.logger.info 'Made it to devise'
        devise_parameter_sanitizer.for(:account_update) do |user_params|
          user_params.permit(:googler, :registration)
        end
    end
end