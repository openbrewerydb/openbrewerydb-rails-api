# frozen_string_literal: true

class BrewerySerializer < ActiveModel::Serializer
  attribute :id
  attribute :name
  attribute :brewery_type
  attribute :street
  attribute :address_2
  attribute :address_3
  attribute :city
  attribute :state
  attribute :county_province
  attribute :postal_code
  attribute :country
  attribute :longitude
  attribute :latitude
  attribute :phone
  attribute :website_url
  attribute :updated_at
  attribute :created_at
end
