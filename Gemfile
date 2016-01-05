source 'https://rubygems.org'
ruby '2.2.3'

gem 'bundler', '>= 1.8.4'

gem 'rails', '4.2.4'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'bootstrap-sass', '~> 3.3.5'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'responders'
gem 'bower-rails'
gem 'angular-rails-templates'
gem "foreman"
gem 'devise_token_auth'
gem 'omniauth-google-oauth2', :git => 'git://github.com/zquestz/omniauth-google-oauth2.git'
gem 'bcrypt', '~> 3.1.10'
gem 'kaminari'
gem 'figaro'
gem 'momentjs-rails'
gem 'rack-cache'
gem 'dalli'
gem 'activerecord-session_store'
gem 'font-kit-rails', '~> 1.2.0'
gem 'google-api-client'
gem 'google_drive'

source 'https://rails-assets.org' do
    gem 'rails-assets-angular'
    gem 'rails-assets-angular-material', '>= 1.0.1'
    gem 'rails-assets-angular-cookie'
    gem 'rails-assets-angular-local-storage'
    gem 'rails-assets-angular-resource'
    gem 'rails-assets-angular-route'
    gem 'rails-assets-ng-token-auth'
end

group :production, :staging do
    gem 'pg'
    gem "rails_12factor"
    gem "rails_stdout_logging"
    gem "rails_serve_static_assets"
    gem 'heroku-deflater'
    gem 'memcachier'
end
group :development, :test do
    gem 'mysql2', '~> 0.3.18'
    # gem 'byebug'
    # gem 'web-console', '~> 2.0'
    gem "rspec-rails", "3.2.1"
    gem "factory_girl_rails", "~> 4.0"
    gem 'faker'
    gem "capybara"
    gem "database_cleaner"
    gem "selenium-webdriver"
    gem 'teaspoon'
    gem 'teaspoon-jasmine'
    gem 'phantomjs'
    gem 'rails-erd'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'puma'