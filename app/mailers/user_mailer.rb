class UserMailer < ApplicationMailer
	
	def welcome_email(user)
		@user = user
		@url = 'www.clerkr.com'
		mail(to: @user.email, subject: 'Clerkr Registration Confirmation')
	end

end
