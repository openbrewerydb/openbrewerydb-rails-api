class AddCountryAndGeocodesToBrewery < ActiveRecord::Migration[5.2]
  def change
    add_column :breweries, :country, :string, after: :postal_code
    add_column :breweries, :longitude, :decimal, after: :country
    add_column :breweries, :latitude, :decimal, after: :longitude
  end
end
