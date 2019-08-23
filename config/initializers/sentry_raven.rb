# frozen_string_literal: true

Raven.configure do |config|
  config.environments = %w[production]
  config.dsn = ENV['RAVEN_DSN']
end
