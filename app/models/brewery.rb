# frozen_string_literal: true

class Brewery < ApplicationRecord
  # Elastic Search via Searchkick
  searchkick word_start: %i[name city state]

  validates :name, presence: true

  scope :by_city, ->(city) { where('lower(city) LIKE ?', "%#{city.downcase}%") }
  scope :by_name, ->(name) { where('lower(name) LIKE ?', "%#{name.downcase}%") }
  scope :by_state, ->(state) { where('lower(state) LIKE ?', "%#{state.downcase}%") }
  scope :by_type, ->(type) { where('lower(brewery_type) = ?', type.downcase) }

  def address
    [street, city, state, country].join(', ')
  end
end
