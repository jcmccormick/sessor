# Author:: Joe McCormick (mailto:joe.c.mccormick@gmail.com)
# Copyright:: Copyright (c) 2015 Joe McCormick
# License:: May not replicate or duplicate in any way.

# The Application Controller includes necessary modules and uses a workaround to define the `current_user`

class ApplicationController < ActionController::Base
    force_ssl if !Rails.env.development?

    # Protect the site from CSRF
    protect_from_forgery with: :null_session#, :if => Proc.new { |c| c.request.format == 'application/json' }

    # Include depdencies for `clean_pagination`, `devise`, and response types.
    include DeviseTokenAuth::Concerns::SetUserByToken
    #include ActionController::MimeResponds

    respond_to :json
    
    def new_session_path(scope)
        new_user_session_path
    end
end