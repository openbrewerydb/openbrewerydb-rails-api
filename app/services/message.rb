# frozen_string_literal: true

class Message
  def self.invalid_credentials
    'Invalid credentials.'
  end

  def self.invalid_auth_token
    'Invalid auth token.'
  end

  def self.missing_auth_token
    'Missing auth token. Sign up via POST /signup. Login via POST /login.'
  end

  def self.account_created
    'Account created successfully!'
  end
end
