source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.5'
gem 'rails-api'

# Database
gem 'pg'

# Development Server
gem 'thin'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '3.1.2'

# Oauth provider 7 client
gem 'oauth2'

# Image Upload and manipulations
gem 'carrierwave'
gem 'fog'
gem 'rmagick', :require => 'rmagick'
gem 'jquery-fileupload-rails'

# AWS SDK for elastic beanstalk
gem 'aws-sdk' # for heroku
gem 'cf-app-utils'
gem 'rails_12factor', :group => [:cucumber, :test]

# Other Dependencies
gem 'jquery-rails'
gem 'state_machine'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails'
gem 'therubyracer', platforms: :ruby
gem 'jbuilder'

# Code Climate
gem "codeclimate-test-reporter", group: :test, require: nil

gem 'poodle-rb', '~> 0.2.3'
#gem 'poodle-rb', path: "/Users/kvarma/Projects/QwinixLabs/q-apps/poodle"

# Poodle Dependencies
gem "handy-css-rails", "0.0.7"
gem "kaminari"
gem "bootstrap-kaminari-views"
gem "bootstrap-datepicker-rails"
gem "jquery-validation-rails"

# Use Capistrano for deployment
group :development do
  gem "parallel_tests"
  gem 'railroady'
  gem 'capistrano'
  gem 'capistrano-rails', '~> 1.1.0'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv', github: "capistrano/rbenv"
  #gem 'capistrano-console'
  #gem "capistrano-ext"
  #gem "capistrano-deploytags"
  gem "brakeman", :require => false
  gem "hirb"
end

group :development, :test do
  gem "factory_girl_rails"
  gem 'pry'
  gem 'pry-doc'
  gem 'pry-rails'
  #gem 'pry-debugger'
  gem "spork", "~> 1.0rc"
  gem "better_errors"
  gem "binding_of_caller"
  gem 'rspec-rails'
  gem "awesome_print"
  gem "quiet_assets"
end

group :it, :staging, :development, :test, :uat, :production do
  gem 'ruby-progressbar'
  gem "colorize"
end

group :test do
  gem "shoulda"
  gem 'cucumber-rails', :require => false
  gem 'cucumber-websteps'
  gem 'pickle'
  gem 'capybara'
  gem 'database_cleaner'
end
