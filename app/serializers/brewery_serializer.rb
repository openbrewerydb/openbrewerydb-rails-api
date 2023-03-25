# frozen_string_literal: true

# JSON Serializer for a Brewery model
class BrewerySerializer < ActiveModel::Serializer
  attribute :id
  attribute :name
  attribute :brewery_type
  attribute :address_1
  attribute :address_2
  attribute :address_3
  attribute :city
  attribute :state_province
  attribute :postal_code
  attribute :country
  attribute :longitude
  attribute :latitude
  attribute :phone
  attribute :website_url

  # DEPRECATED - Will be removed at a TBD date
  attribute :state
  attribute :street
end
