# frozen_string_literal: true

FactoryBot.define do
  factory :brewery do
    name { "#{Faker::Company.name} Brewery" }
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    phone { Faker::PhoneNumber.phone_number }
    postal_code { Faker::Address.postcode }
    country { Faker::Address.country }
    brewery_type { %w[micro planning brewpub].sample }
    website_url { Faker::Internet.url }
  end
end
