# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :breweries do
    get '/', to: 'breweries#index'
    get '/autocomplete', to: 'breweries#autocomplete'
    get '/meta', to: 'breweries#meta'
    get '/random', to: 'breweries#random'
    get '/search', to: 'breweries#search'
    get '/:id', to: 'breweries#show'
  end

  namespace :v1 do
    namespace :breweries do
      get '/', to: 'breweries#index'
      get '/autocomplete', to: 'breweries#autocomplete'
      get '/meta', to: 'breweries#meta'
      get '/random', to: 'breweries#random'
      get '/search', to: 'breweries#search'
      get '/:id', to: 'breweries#show'
    end
  end

  # Otherwise, redirect to www
  root to: redirect('https://www.openbrewerydb.org/')
end
