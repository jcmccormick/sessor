Devise.setup do |config|
  config.navigational_formats = [:json]
  Warden::Manager.before_logout do |user,auth,opts|
    auth.cookies.delete :_clerkr_session
  end
end