# frozen_string_literal: true

FactoryBot.define do
  factory :brewery do
    id { Faker::Internet.uuid }
    name { "#{Faker::Company.name} Brewery" }
    brewery_type { %w[micro planning brewpub].sample }
    address_1 { Faker::Address.street_address }
    address_2 { Faker::Address.secondary_address }
    address_3 { nil }
    city { Faker::Address.city }
    state_province { Faker::Address.state }
    phone { Faker::PhoneNumber.phone_number }
    postal_code { Faker::Address.postcode }
    country { Faker::Address.country }
    website_url { Faker::Internet.url }
  end
end
