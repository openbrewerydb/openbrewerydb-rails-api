# frozen_string_literal: true

Rails.application.routes.draw do
  # Restricting routes until the implemention of user authentication
  resources :breweries, only: %i[index show]

  # Sign-up
  post 'signup', to: 'users#create'
end
