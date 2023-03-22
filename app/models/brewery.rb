# frozen_string_literal: true

require 'uuid_validator'

# Brewery Model
class Brewery < ApplicationRecord
  self.table_name = ENV.fetch('BREWERY_TABLE', 'breweries')

  # Elastic Search via Searchkick
  searchkick

  geocoded_by :address

  acts_as_mappable lat_column_name: :latitude, lng_column_name: :longitude

  validates :id, presence: true, uniqueness: true, uuid: true
  validates :name, presence: true
  validates :city, presence: true
  validates :state_province, presence: true
  validates :country, presence: true

  scope :by_type, ->(type) { where('lower(brewery_type) = ?', type.downcase) }
  scope :by_ids, ->(ids) { where(id: ids.split(',')) }
  scope :by_city, lambda { |city|
    where(
      'lower(city) LIKE ?',
      "%#{sanitize_sql_like(city.gsub('+', ' ').downcase)}%"
    )
  }
  scope :by_country, lambda { |country|
    where(
      'lower(country) LIKE ?',
      "%#{sanitize_sql_like(country.gsub('+', ' ').downcase)}%"
    )
  }
  scope :by_name, lambda { |name|
    where(
      'lower(name) LIKE ?',
      "%#{sanitize_sql_like(name.gsub('+', ' ').downcase)}%"
    )
  }
  scope :by_state, lambda { |state|
    where(
      'lower(state_province) LIKE ?',
      "%#{sanitize_sql_like(state.gsub('+', ' ').downcase)}%"
    )
  }
  scope :by_postal, lambda { |postal|
    where('postal_code LIKE ?', "%#{sanitize_sql_like(postal)}%")
  }
  scope :by_dist, lambda { |coords|
    by_distance(origin: coords.split(',').map(&:to_f).first(2))
  }
  scope :exclude_types, lambda { |types|
    where('lower(brewery_type) NOT IN (?)', types.split(','))
  }

  def address
    [address_1, city, state_province, country].join(', ')
  end

  def country_us?
    country == 'United States'
  end

  def search_data
    {
      name:,
      city:,
      state:
    }
  end
end
