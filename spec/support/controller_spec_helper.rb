# frozen_string_literal: true

module ControllerSpecHelper
  def token_generator(user_id, expires_at = 24.hours.from_now)
    JsonWebToken.encode({ user_id: user_id }, expires_at)
  end

  def valid_headers
    {
      'Authorization' => token_generator(user.id),
      'Content-Type' => 'application/json'
    }
  end

  def invalid_headers
    {
      'Authorization' => nil,
      'Content-Type' => 'application/json'
    }
  end
end
