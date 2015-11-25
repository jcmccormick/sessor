Devise.setup do |config|
	config.mailer_sender = 'support@clerkr.com'
	config.secret_key = ENV['DEVISE_KEY']
end