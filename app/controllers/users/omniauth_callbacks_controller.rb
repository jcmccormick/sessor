class Users::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController

    def omniauth_success
        super do |resource|
            user_session['gaccess_token'] = auth_hash['credentials']['token']
            user_session['grefresh_token'] = auth_hash['credentials']['refresh_token']
            user_session['gexpires_at'] = auth_hash['credentials']['expires_at']
            @omniauth_success_block_called = true
        end
    end

    def omniauth_success_block_called?
        @omniauth_success_block_called == true
    end

end