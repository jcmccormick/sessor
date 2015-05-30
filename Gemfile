source 'https://rubygems.org'
ruby '2.1.6'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use mysql as the database for Active Record
gem 'mysql2'
# Use postgresql as the database for Heroku
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# gem 'sass-rails', '4.0.2' -- May need older version
# gem 'sass', '3.2.19'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'responders'
gem 'bower-rails'
gem 'angular-rails-templates'
gem 'actionpack-page_caching'
gem "foreman"
group :production, :staging do
  gem "rails_12factor"
  gem "rails_stdout_logging"
  gem "rails_serve_static_assets"
end
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem "rspec-rails", "3.2.1"
  gem "factory_girl_rails", "~> 4.0"
  gem "capybara"
  gem "database_cleaner"
  gem "selenium-webdriver"
  gem 'phantomjs'
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]