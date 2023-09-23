source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.8"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

gem 'active_interaction', '~> 5.2.0'

gem 'text-table', '~> 1.2.4'

gem 'redis', '~> 4.3.1'

gem 'redis-namespace', '~> 1.8.2'

gem 'sidekiq-cron', '~> 1.7.0'

gem 'bcrypt', '~> 3.1.7'

gem 'rack-cors', '~> 1.1.1'

gem 'rubyzip', '~> 2.3.2'

gem 'will_paginate', '~> 3.3.0'

gem 'activerecord-import', '~> 1.3.0'

gem 'simple_command', '~> 0.1.0'

gem 'oj', '~> 3.14.3'

gem 'oj_mimic_json', '~> 1.0.1'

# gem 'rotp', '~> 6.2.0'

gem 'jwt', '~> 2.2.3'

gem 'mail', '~> 2.7.1'

# Use Sidekiq for background jobs
gem 'sidekiq', '~> 6.2.1'

gem 'sidekiq-status', '~> 3.0.3'

gem 'timeout', '~> 0.3.2'

# gem 'mustache', '~> 1.1.1'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  gem 'database_cleaner', '~> 2.0.1', require: false
  gem 'factory_bot_rails', '~> 6.2.0', require: false
  gem 'faker', '~> 3.0.0', require: false
  gem 'pry', require: false
  gem 'rspec-rails', '~> 6.0.1'
  gem 'shoulda-matchers', '~> 5.2.0', require: false
  gem 'rails-controller-testing', '~> 1.0.5'

  gem 'guard', '~> 2.18.0'
  gem 'guard-rspec', '~> 4.7.3'
  gem 'guard-rails', '~> 0.8.1'
  gem 'guard-test', '~> 2.0.8'
  gem 'launchy', '~> 2.5.2'
  gem 'caxlsx', '~> 3.4.1'
  gem 'roo', '~> 2.10.0', require: false
  gem 'webmock', '~> 3.18.1'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
