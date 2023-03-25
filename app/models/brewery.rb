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

  # Filter by `brewery_type`
  scope :by_type, ->(type) { where('lower(brewery_type) = ?', type.downcase) }
  # Filter by multiple, comma-separated `id`s
  scope :by_ids, ->(ids) { where(id: ids.split(',')) }
  # Filter by `city`
  scope :by_city, lambda { |city|
    where(
      'lower(city) LIKE ?',
      "%#{sanitize_sql_like(city.gsub('+', ' ').downcase)}%"
    )
  }
  # Filter by `country`
  scope :by_country, lambda { |country|
    where(
      'lower(country) LIKE ?',
      "%#{sanitize_sql_like(country.gsub('+', ' ').downcase)}%"
    )
  }
  # Sort by the distance from a `latitude`,`longitude` geo point
  scope :by_dist, lambda { |coords|
    by_distance(origin: coords.split(',').map(&:to_f).first(2))
  }
  # Filter by `name`
  scope :by_name, lambda { |name|
    where(
      'lower(name) LIKE ?',
      "%#{sanitize_sql_like(name.gsub('+', ' ').downcase)}%"
    )
  }
  # Filter by `postal_code`
  scope :by_postal, lambda { |postal|
    where('postal_code LIKE ?', "%#{sanitize_sql_like(postal)}%")
  }
  # Filter by `state_province`
  scope :by_state, lambda { |state|
    where(
      'lower(state_province) LIKE ?',
      "%#{sanitize_sql_like(state.gsub('+', ' ').downcase)}%"
    )
  }
  # Filter by exluding the comma-separated `brewery_types`
  scope :exclude_types, lambda { |types|
    where('lower(brewery_type) NOT IN (?)', types.split(','))
  }

  def address
    [address_1, city, state_province, country].join(', ')
  end

  # DEPRECATED - Will be removed at a TBD date
  def state
    state_province
  end

  # DEPRECATED - Will be removed at a TBD date
  def street
    address_1
  end

  # For Searchkick
  def search_data
    {
      id:,
      name:,
      city:,
      state_province:,
      postal_code:,
      country:,
      latitude:,
      longitude:
    }
  end
end
