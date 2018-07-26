# frozen_string_literal: true

class UsersController < ApplicationController
  # POST /signup
  def create
    User.create!(user_params)
    json_response({ message: Message.account_created }, :created)
  end

  private

    def user_params
      params.permit(:email, :password)
    end
end
