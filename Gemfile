source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
gem 'pg', '~> 0.18.4'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'dotenv-rails' #, groups: [:development, :test]
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'rspec-rails', '~> 3.8'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # deplou
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'capistrano-passenger'
  # sidekiq deployment
  gem 'capistrano-sidekiq', github: 'seuros/capistrano-sidekiq'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
# admin dashboard
gem 'adminlte2-rails'
# User management
gem 'devise'
#haml
gem 'haml-rails'
#friendly urls
gem 'friendly_id', '~> 5.1.0' # Note: You MUST use 5.0.0 or greater for Rails 4.0+
#Chart plotting
gem 'chartjs-ror'
#date formatting
gem 'groupdate'
# annotate the database
gem 'annotate', '~> 2.7', '>= 2.7.2'
# bootstrap it
gem 'bootstrap-sass' #enables bootstrap in te app
# uploads and attachements
gem 'paperclip'
# dealing with forms
gem 'simple_form', '~> 3.5'
# API 
gem 'jsonapi-rails'
# gem 'jsonapi_suite', '~> 0.5'

gem 'rake'
# Pagination
gem 'will_paginate', '~> 3.1.1'
# api pagination
gem 'api-pagination'
#sending mails
gem 'sidekiq'
# API authentication
gem 'devise_token_auth'
# facebook/google sign in
# gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
# gem 'omniauth', '~> 1.8', '>= 1.8.1'
# Search plugins

gem 'elasticsearch-model', '~> 5.0', '>= 5.0.2'
gem 'elasticsearch-rails', '~> 5.0', '>= 5.0.2'
gem 'searchkick' #making things easier to do on searchkick
# styling check boxes
gem 'icheck-rails'
# fast json response
gem 'oj'
gem 'fast_jsonapi'
# Resources
gem 'jsonapi-resources' #, :git => 'https://github.com/cerebris/jsonapi-resources.git'
# soft delete
gem "paranoia", "~> 2.2"