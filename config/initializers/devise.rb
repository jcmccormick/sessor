Devise.setup do |config|
    config.mailer_sender = 'mailer@example.com'
    config.secret_key = ENV['DEVISE_KEY']
    config.expire_all_remember_me_on_sign_out = true
    config.sign_out_via = :delete
    config.skip_session_storage = [:http_auth, :token_auth]
    config.omniauth :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {scope: "email, profile, https://www.googleapis.com/auth/drive, https://spreadsheets.google.com/feeds/", prompt: 'consent'}
end