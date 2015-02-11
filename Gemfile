source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.8'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development


# Extra Gems
gem 'twilio-ruby'
gem 'mongoid'
gem 'simple_form'
gem 'devise'
gem 'foundation-rails'
gem 'nested_form_fields'
gem 'carrierwave'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'carrierwave-processing'
gem 'mini_magick'
gem 'octokit', '~> 3.0'
gem 'omniauth'
gem 'omniauth-github'
gem 'bunny', '>=1.6.2'
gem 'json'


# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# Use CoffeeScript for .js.coffee assets and views
gem 'therubyrhino', group: :assets


group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets'
  # simple SMTP server
  gem 'mailcatcher'
  # run as mailcatcher
  # access through http://localhost:1080/
  gem 'rails_layout'
end

group :test do
  gem 'capybara'
  gem 'cucumber-rails', :require => false
  # database_cleaner is not required, but highly recommended
  gem 'database_cleaner'
  gem 'rspec-expectations'
  gem 'factory_girl_rails'
  gem 'selenium-webdriver'
end

group :production do
  gem 'nokogiri'
  gem 'postmark-rails'
  gem 'rails_12factor'
end
