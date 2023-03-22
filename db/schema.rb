# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_03_21_000000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "breweries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "brewery_type", null: false
    t.string "address_1"
    t.string "address_2"
    t.string "address_3"
    t.string "city", null: false
    t.string "state_province", null: false
    t.string "country", null: false
    t.string "postal_code", null: false
    t.string "website_url"
    t.string "phone"
    t.decimal "longitude"
    t.decimal "latitude"
    t.index ["id"], name: "index_breweries_on_id"
  end

end
