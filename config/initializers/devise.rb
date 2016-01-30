Devise.setup do |config|
    config.mailer_sender = 'mailer@example.com'
    config.secret_key = ENV['DEVISE_KEY']
    config.expire_all_remember_me_on_sign_out = true
    config.sign_out_via = :delete
    config.skip_session_storage = [:http_auth, :token_auth]
end