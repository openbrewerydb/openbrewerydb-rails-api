# frozen_string_literal: true

Rails.application.routes.draw do
  resources :breweries, only: %i[index show] do
    get 'autocomplete', on: :collection
    get 'search', on: :collection
  end

  # Redirect to WWW
  root to: redirect('https://www.openbrewerydb.org/')
end
