Rails.application.config.middleware.use OmniAuth::Builder do
	if Rails.env.development?
		provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {:client_options => {:ssl => {:verify => false}}, skip_jwt: true}
	else
		provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']
	end
end