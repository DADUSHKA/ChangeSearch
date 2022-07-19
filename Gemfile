# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.0"

gem "bootsnap", ">= 1.1.0", require: false
gem "coffee-rails", "~> 4.2"
gem "dotenv-rails"
gem "jbuilder", "~> 2.5"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 3.11"
gem "rails", "~> 5.2.2"
gem "sass-rails", "~> 5.0"
gem "turbolinks", "~> 5"
gem "uglifier", ">= 1.3.0"
# Gems set in hand
gem "active_model_serializers", "~> 0.10"
gem "cancancan"
gem "cocoon"
gem "devise"
gem "doorkeeper"
gem "gon"
gem "jquery-rails"
gem "materialize-sass"
gem "mini_racer"
gem "oj"
gem "omniauth", "~> 1.6"
gem "omniauth-facebook"
gem "omniauth-github", "~> 1.1"
gem "pg_search"
gem "redis-rails"
gem "select2-rails"
gem "sidekiq"
gem "sinatra", require: false
gem "skim"
gem "slim-rails"
gem "unicorn"
gem "valid_url"
gem "whenever", require: false


group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails"
  gem "faker", git: "https://github.com/stympy/faker.git", branch: "master"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rspec-rails", "~>3.8"
end

group :development do
  gem "guard", require: false
  gem "guard-bundler", require: false
  gem "guard-rails", require: false
  gem "guard-rspec", require: false
  gem "guard-spring", require: false
  gem "letter_opener"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "rubocop", "1.30.1", require: false # should be updated from time to time
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "spring"
  gem "spring-commands-rack-console"
  gem "spring-commands-rspec"
  gem "spring-commands-rubocop"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
  # gem 'jazz_fingers'
  gem "capistrano", require: false
  # gem "capistrano3-unicorn", require: false
  gem "capistrano-bundler", require: false
  gem "capistrano-passenger", require: false
  gem "capistrano-rails", require: false
  gem "capistrano-rvm", require: false
  # gem "capistrano-sidekiq", require: false
end

group :test do
  gem "capybara", ">= 2.15"
  gem "capybara-email"
  gem "chromedriver-helper"
  gem "database_cleaner"
  gem "fuubar"
  gem "launchy"
  gem "rails-controller-testing"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "bcrypt_pbkdf", ">= 1.0", "< 2.0"
gem "ed25519", ">= 1.2", "< 2.0"
gem "net-ssh", ">= 6.0.2"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
