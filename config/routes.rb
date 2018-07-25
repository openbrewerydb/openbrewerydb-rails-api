# frozen_string_literal: true

Rails.application.routes.draw do
  resources :breweries

  # Authentication
  post 'login', to: 'authentication#authenticate'

  # Sign-up
  post 'signup', to: 'users#create'
end
