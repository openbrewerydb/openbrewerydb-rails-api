# frozen_string_literal: true

# Exception Handler module
module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from Faraday::ConnectionFailed, with: :service_unavailable
  end

  private

  def not_found(exception)
    json_response({ message: exception.message }, :not_found)
  end

  def service_unavailable
    json_response(
      {
        message: 'There is an issue connecting to a service. Please report to info@openbrewerydb.org.'
      },
      :service_unavailable
    )
  end

  def too_many_requests
    json_response(
      {
        message: 'Concurrent request limit exceeded. Please delay concurrent calls using debounce or throttle.'
      },
      :too_many_requests
    )
  end

  def unprocessable_entity(exception)
    json_response({ message: exception.message }, :unprocessable_entity)
  end
end
