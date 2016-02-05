module Sheeted extend ActiveSupport::Concern
    included do
    end

    def google_drive
        refresh_google_oauth2_token if token_is_old
        Rails.logger.info user_session
        GoogleDrive.login_with_oauth(user_session['gaccess_token'])
    end

    def create_spreadsheet(name)
        google_drive.create_spreadsheet(name)
    end

    def spreadsheet(name)
        google_drive.file_by_title(name)
    end

    def worksheet(url)
        google_drive.worksheet_by_url(url)
    end

    def refresh_google_oauth2_token
        oauth_client = OAuth2::Client.new(
            ENV['GOOGLE_CLIENT_ID'],
            ENV['GOOGLE_CLIENT_SECRET'],
            :site => "https://accounts.google.com",
            :token_url => "/o/oauth2/token",
            :authorize_url => "/o/oauth2/auth",
            :ssl => {:verify => !Rails.env.development?}
        )
        access_token = OAuth2::AccessToken.from_hash(oauth_client, {:refresh_token => user_session['grefresh_token']})
        access_token = access_token.refresh!
        user_session['gaccess_token'] = access_token.token
        user_session['gexpires_at'] = Time.now + access_token.expires_in
    end

    def token_is_old
        Time.at(user_session['gexpires_at']) < Time.now()
    end
end