# frozen_string_literal: true

Rails.application.routes.draw do
  resources :breweries
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
end
