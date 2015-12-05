# Rails.application.config.middleware.use OmniAuth::Builder do
#   if Rails.env.development?
#     provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {:client_options => {:ssl => {:verify => false}}, skip_jwt: true, scope: "email, profile, https://www.googleapis.com/auth/drive, https://spreadsheets.google.com/feeds/", access_type: 'offline', prompt: 'consent'}
#   else
#     provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {scope: "email, profile, https://www.googleapis.com/auth/drive, https://spreadsheets.google.com/feeds/", access_type: 'offline', prompt: 'consent'}
#   end
# end