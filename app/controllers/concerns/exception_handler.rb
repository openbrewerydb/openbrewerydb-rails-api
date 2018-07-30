# frozen_string_literal: true

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

    def service_unavailable()
      json_response(
        {
          message: 'There is an issue connecting to the ElasticSearch server. '\
                   'Please try again or use other filter options. Example: '\
                   'https://api.openbrewerydb.org/breweries?by_state=OH&sort=city'
        },
        :service_unavailable
      )
    end

    def unprocessable_entity(exception)
      json_response({ message: exception.message }, :unprocessable_entity)
    end
end
