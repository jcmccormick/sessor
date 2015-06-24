Devise.setup do |config|
  config.navigational_formats = [:json]
  Warden::Manager.after_set_user do |user,auth,opts|
    auth.cookies[:signed_in] = 1
  end

  Warden::Manager.before_logout do |user,auth,opts|
    auth.cookies.delete :signed_in
  end
end