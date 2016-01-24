source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'

# Lock sprockets
gem 'sprockets', '2.12.3'

# Puma webserver
gem 'puma'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# SSL -- Lets Encrypt needs to be updated to be compatible with ruby 2.2.3
# gem 'letsencrypt_plugin' 

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Required for checking JSON response when wrapping parameters
gem 'responders'

# Pagination library
gem 'kaminari'

# Easy environment variables locally and on heroku
gem 'figaro'

# Caching utils
gem 'rack-cache'
gem 'dalli'

# Session store
gem 'activerecord-session_store'

# Angular Templates
gem 'angular-rails-templates'

# Auth
gem 'devise_token_auth'
gem 'omniauth-google-oauth2', :git => 'git://github.com/zquestz/omniauth-google-oauth2.git'
gem 'google-api-client'
gem 'google_drive'

# Some native fonts
gem 'font-kit-rails', '~>1.2.0'

# Front end dependencies
source 'https://rails-assets.org' do
    gem 'rails-assets-angular'
    gem 'rails-assets-angular-animate'
    gem 'rails-assets-angular-aria'
    gem 'rails-assets-angular-cookie'
    gem 'rails-assets-angular-flash-alert'
    gem 'rails-assets-angular-local-storage'
    gem 'rails-assets-angular-material', '0.9.8'
    gem 'rails-assets-angular-mocks'
    gem 'rails-assets-angular-resource'
    gem 'rails-assets-angular-route'
    gem 'rails-assets-moment'
    gem 'rails-assets-ng-token-auth'
    gem 'rails-assets-underscore'
end

group :development, :test do
    # Call 'byebug' anywhere in the code to stop execution and get a debugger console
    gem 'byebug'
end

group :development do
    # Access an IRB console on exception pages or by using <%= console %> in views
    gem 'web-console', '~> 2.0'
end


group :production, :staging do
    gem "rails_12factor"
    gem "rails_stdout_logging"
    gem "rails_serve_static_assets"
    gem 'heroku-deflater'
    gem 'memcachier'
end
