# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates_presence_of :email, :password_digest
  validates :email, uniqueness: { case_sensitive: false }
end
