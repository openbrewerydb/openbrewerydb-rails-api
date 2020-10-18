# frozen_string_literal: true

FactoryBot.define do
  factory :brewery do
    name { "#{Faker::Company.name} Brewery" }
    street { Faker::Address.street_address }
    address_2 { Faker::Address.secondary_address }
    address_3 { nil }
    city { Faker::Address.city }
    state { Faker::Address.state }
    county_province { nil }
    phone { Faker::PhoneNumber.phone_number }
    postal_code { Faker::Address.postcode }
    country { Faker::Address.country }
    brewery_type { %w[micro planning brewpub].sample }
    website_url { Faker::Internet.url }
  end
end
