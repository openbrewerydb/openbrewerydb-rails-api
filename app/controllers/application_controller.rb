# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  # Sentry error reporting
  before_action :set_raven_context

  private

    def set_raven_context
      Raven.extra_context(params: params.to_unsafe_h, url: request.url)
    end
end
