# frozen_string_literal: true

Rails.application.routes.draw do
  resources :breweries

  # Sign-up
  post 'signup', to: 'users#create'
end
