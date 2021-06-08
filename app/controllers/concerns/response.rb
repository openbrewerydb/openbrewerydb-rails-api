# frozen_string_literal: true

# Response helper module
module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end
end
