# frozen_string_literal: true

# Brewery Model
class Brewery < ApplicationRecord
  self.table_name = ENV.fetch('BREWERY_TABLE', 'breweries')

  # In case model table is a view (i.e., no primary key specified)
  self.primary_key = 'id'

  # Elastic Search via Searchkick
  searchkick

  geocoded_by :address

  acts_as_mappable lat_column_name: :latitude, lng_column_name: :longitude

  validates :name, presence: true
  validates :city, presence: true
  validates :state, presence: true, if: :country_us?
  validates :country, presence: true
  validates :obdb_id, presence: true, uniqueness: true

  scope :by_city, ->(city) { where('lower(city) LIKE ?', "%#{sanitize_sql_like(city.downcase)}%") }
  scope :by_country, ->(country) { where('lower(country) = ?', country.downcase) }
  scope :by_name, ->(name) { where('lower(name) LIKE ?', "%#{sanitize_sql_like(name.downcase)}%") }
  scope :by_state, ->(state) { where('lower(state) LIKE ?', "%#{sanitize_sql_like(state.downcase)}%") }
  scope :by_type, ->(type) { where('lower(brewery_type) = ?', type.downcase) }
  scope :by_postal, ->(postal) { where('postal_code LIKE ?', "%#{sanitize_sql_like(postal)}%") }
  scope :by_ids, ->(ids) { where(id: ids.split(',')) }
  scope :by_dist, ->(coords) { by_distance(origin: coords.split(',').map(&:to_f).first(2)) }
  scope :exclude_types, ->(types) { where('lower(brewery_type) NOT IN (?)', types.split(',')) }

  def address
    [street, city, state, country].join(', ')
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
