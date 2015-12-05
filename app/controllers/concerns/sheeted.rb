module Sheeted extend ActiveSupport::Concern
    included do
    end

    def google_drive
        current_user.refresh_google_oauth2_token if current_user.token_is_old
        GoogleDrive.login_with_oauth(current_user.access_token)
    end

    def worksheet
        @worksheet
    end

    def spreadsheet
        @spreadsheet
    end

    def create_spreadsheet(name)
        @spreadsheet = google_drive.create_spreadsheet(name)
    end

    def call_worksheet(id)
        @worksheet = google_drive.worksheet_by_url(id)
    end

end