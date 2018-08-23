# frozen_string_literal: true

class BrewerySerializer < ActiveModel::Serializer
  attribute :id
  attribute :name
  attribute :brewery_type
  attribute :street
  attribute :city
  attribute :state
  attribute :postal_code
  attribute :country
  attribute :longitude
  attribute :latitude
  attribute :phone
  attribute :website_url
  attribute :updated_at
end
