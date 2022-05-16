# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.1'

# Analytics
gem 'ahoy_matey', '~> 3.2'

# Backend
gem 'bcrypt', '~> 3.1'
gem 'faraday', '~> 1.4'
gem 'geocoder', '~> 1.6'
gem 'geokit-rails', '~> 2.3'
gem 'has_scope', '~> 0.8'
gem 'jwt', '~> 2.2'
gem 'nokogiri', '~> 1.13'
gem 'puma', '~> 4.3'
gem 'rack', '>= 2.2'
gem 'rack-cors', '~> 1.1'
gem 'rails', '~> 6.1'
gem 'rexml'
gem 'sentry-rails'

# Elastic Search
gem 'searchkick', '~> 4.6'

# Pagination
gem 'kaminari', '~> 1.2'

# Database
gem 'pg', '~> 1.2.3'

# Frontend
gem 'active_model_serializers', '~> 0.10'
gem 'bootsnap', '>= 1.1', require: false
gem 'colorize', '~> 0.8'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '~> 2.7'
  gem 'guard-rspec', '~> 4.7'
  gem 'rspec-rails', '~> 5.0'
  gem 'rubocop-rails', '~> 2.10', require: false
  gem 'rubocop-rspec', '~> 2.3', require: false
end

group :test do
  gem 'database_cleaner', '~> 2.0'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 2.17'
  gem 'rspec_junit_formatter', '~> 0.4'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'simplecov', '~> 0.21', require: false
end

group :development do
  gem 'listen', '~> 3.2'
  gem 'spring', '~> 2.1'
  gem 'spring-watcher-listen', '~> 2.0'
end

group :production do
  gem 'cloudflare-rails', '~> 2.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
