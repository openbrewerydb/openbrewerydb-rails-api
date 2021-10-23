# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.rails.report_rescued_exceptions = true
  config.breadcrumbs_logger = [:active_support_logger]
end
