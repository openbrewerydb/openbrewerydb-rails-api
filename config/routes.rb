# frozen_string_literal: true

Rails.application.routes.draw do
  # Restricting routes until the implemention of user authentication
  resources :breweries, only: %i[index show] do
    get 'autocomplete', on: :collection
    get 'search', on: :collection
  end

  # Sign-up
  post 'signup', to: 'users#create'

  # Redirect to WWW
  root to: redirect('https://www.openbrewerydb.org/')
end
