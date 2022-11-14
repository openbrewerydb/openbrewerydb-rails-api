# frozen_string_literal: true

Rails.application.routes.draw do
  get '/breweries/autocomplete', to: 'breweries#autocomplete'
  get '/breweries/meta', to: 'breweries#meta'
  get '/breweries/random', to: 'breweries#random'
  get '/breweries/search', to: 'breweries#search'
  get '/breweries/:id', to: 'breweries#show'
  get '/breweries', to: 'breweries#index'

  # Otherwise, redirect to www
  root to: redirect('https://www.openbrewerydb.org/')
end
