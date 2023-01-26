# rake db:schema:load

ActiveRecord::Schema.define(version: 2023_01_20_000000) do
  create_table "breweries", force: :cascade do |t|
    t.string "name"
    t.string "brewery_type"
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "website_url"
    t.string "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "country"
    t.decimal "longitude"
    t.decimal "latitude"
    t.string "address_2"
    t.string "address_3"
    t.string "county_province"
    t.string "obdb_id"
    t.index ["obdb_id"], name: "breweries_obdb_id_key", unique: true
  end
end
