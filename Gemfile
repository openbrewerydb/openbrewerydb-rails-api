source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.2'

# Backend
gem 'bcrypt'
gem 'jwt'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.0'

# Database
gem 'pg', group: [:production, :development]
gem 'sqlite3', group: [:test]

# Frontend
gem 'bootsnap', '>= 1.1.0', require: false
gem 'rack-cors'
gem 'colorize'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec_junit_formatter'
  gem 'simplecov', require: false
  gem 'shoulda-matchers', '~> 3.1'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
