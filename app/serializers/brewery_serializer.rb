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

  # Deprecated - Will be removed at a TBD date
  # TODO: Not sure this is how you do this
  # attribute :state, key: :state_province
  # attribute :street, key: :address_1
end
