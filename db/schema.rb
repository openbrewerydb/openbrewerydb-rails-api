# rake db:schema:load

ActiveRecord::Schema.define(version: 2023_01_07_000000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "breweries", force: :cascade do |t|
    t.string "name"
    t.string "brewery_type"
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "website_url"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "country"
    t.decimal "longitude"
    t.decimal "latitude"
    t.string "address_2"
    t.string "address_3"
    t.string "county_province"
    t.string "obdb_id"
    t.text "tags"
    t.index ["obdb_id"], name: "breweries_obdb_id_key", unique: true
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end
end
