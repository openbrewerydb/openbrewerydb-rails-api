class AddColumnsToBreweries < ActiveRecord::Migration[5.2]
  def change
    add_column :breweries, :address_2, :string
    add_column :breweries, :address_3, :string
    add_column :breweries, :county_province, :string
  end
end
