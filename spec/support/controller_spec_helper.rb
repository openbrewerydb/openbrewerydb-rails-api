# frozen_string_literal: true

module ControllerSpecHelper
  def token_generator(user_id, expires_at = 24.hours.from_now)
    JsonWebToken.encode({ user_id: user_id }, expires_at)
  end
end
