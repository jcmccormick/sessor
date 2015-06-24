module ApplicationHelper
	def devise_current_user
	   @devise_current_user ||= warden.authenticate(:scope => :user)
	end
end
