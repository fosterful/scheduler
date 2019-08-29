source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'
gem 'react-rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Lib for building admin
gem 'administrate'

# User registration & authorization
gem 'devise'
gem 'devise_invitable'

# For user permissions
gem 'pundit'

# Address Verification & Geocoding
gem 'mainstreet'
gem 'geocoder', github: 'ankane/geocoder', branch: 'smarty_streets_international'

gem 'haml-rails'

# For expanding rrule strings
gem 'rrule'

# For callable service objects
gem 'procto'
gem 'adamantium'
gem 'concord'

gem 'redis-namespace'
gem 'sidekiq'
gem 'twilio-ruby'

# Exception monitoring
gem 'honeybadger', '~> 4.0'

# For phone number validation/formatting
gem 'telephone_number'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'awesome_print'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'
  gem 'faker'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'rspec-collection_matchers'
  gem 'shoulda-matchers'
  gem 'pundit-matchers'
  gem 'factory_bot_rails'
  gem 'rspec_junit_formatter'
  gem 'rspec-jumpstart'
  gem 'spring-commands-rspec'
  gem 'rails-controller-testing'
  gem 'webmock'
  gem 'vcr'
end

gem 'simplecov', :require => false, :group => :test

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'hint-rubocop_style', '~> 0.3.2'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'mutant',  github: 'mbj/mutant', ref: '90d103dc323eded68a7e80439def069f18b5e990'
  gem 'mutant-rspec',  github: 'mbj/mutant', ref: '90d103dc323eded68a7e80439def069f18b5e990'
  gem 'selenium-webdriver'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
