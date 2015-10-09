Devise.setup do |config|
	config.mailer_sender = "support@clerkr.com"
	config.navigational_formats = [:json]
	config.secret_key = 'a2bb79020d9703ed1090ba022abf233e2602fff449ce7edcd101d66331d301e973f609c105f2994333dc9c4d51c550744208fc6b19f2fdb01a5e2eea17ec38b6'
end