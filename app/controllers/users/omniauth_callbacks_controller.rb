class Users::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController

    def omniauth_success
        super do |resource|
            Rails.logger.info 'HEY THERE'
            Rails.logger.info user_session
            user_session['gauth_token'] = auth_hash['credentials']['token']
            user_session['grefresh_token'] = auth_hash['credentials']['refresh_token']
            user_session['gexpires_at'] = auth_hash['credentials']['expires_at']
            Rails.logger.info user_session
            @omniauth_success_block_called = true
        end
    end
    
    def omniauth_success_block_called?
        @omniauth_success_block_called == true
    end

end