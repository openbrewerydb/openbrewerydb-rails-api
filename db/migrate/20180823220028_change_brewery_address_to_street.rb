class ChangeBreweryAddressToStreet < ActiveRecord::Migration[5.2]
  def change
    rename_column :breweries, :address, :street
  end
end
