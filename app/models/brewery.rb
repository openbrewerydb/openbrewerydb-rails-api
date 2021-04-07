# frozen_string_literal: true

class Brewery < ApplicationRecord
  # Elastic Search via Searchkick
  searchkick word_start: %i[name city state]

  geocoded_by :address
  after_validation :geocode

  acts_as_mappable :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  validates :name, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :obdb_id, presence: true, uniqueness: true

  scope :by_city, ->(city) { where('lower(city) LIKE ?', "%#{city.downcase}%") }
  scope :by_country, ->(country) { where('lower(country) = ?', country.downcase) }
  scope :by_name, ->(name) { where('lower(name) LIKE ?', "%#{name.downcase}%") }
  scope :by_state, ->(state) { where('lower(state) LIKE ?', state.downcase) }
  scope :by_type, ->(type) { where('lower(brewery_type) = ?', type.downcase) }
  scope :by_postal, ->(postal) { where('postal_code LIKE ?', "#{postal}%") }
  scope :by_ids, ->(ids) { where(id: ids.split(",")) }
  scope :by_dist, ->(coords) { by_distance(:origin => coords.split(',').map { |coord| coord.to_f }.first(2)) }

  def address
    [street, city, state, country].join(', ')
  end
end
