class CreateBreweries < ActiveRecord::Migration[5.2]
  def change
    create_table :breweries do |t|
      t.string :name
      t.string :brewery_type
      t.string :address
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :website_url
      t.string :phone

      t.timestamps
    end
  end
end
