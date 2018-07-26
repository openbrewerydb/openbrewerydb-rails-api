# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
  end

  private

    def not_found(exception)
      json_response({ message: exception.message }, :not_found)
    end

    def unprocessable_entity(exception)
      json_response({ message: exception.message }, :unprocessable_entity)
    end
end
