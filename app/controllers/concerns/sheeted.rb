module Sheeted extend ActiveSupport::Concern
    included do
    end

    def google_drive
        if !@gd_session || current_user.token_is_old
            current_user.refresh_google_oauth2_token if current_user.token_is_old
            @gd_session = GoogleDrive.login_with_oauth(current_user.access_token)
        else
            @gd_session
        end
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

end