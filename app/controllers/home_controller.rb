# The Home Controller is required for Rails to show the "home#index" root view (app/views/home/index.html.erb). This controller is essentially a connector which separates the basic Rails layout (app/views/layouts/application.html.erb) from the AngularJS front-end.

class HomeController < ApplicationController

  # Create empty method to allow Rails to pass information.
  def index
  end
end