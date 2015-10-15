Devise.setup do |config|
	config.mailer_sender = "support@clerkr.com"
	config.navigational_formats = [:json]
	config.secret_key = ENV['DEVISE_KEY']
end