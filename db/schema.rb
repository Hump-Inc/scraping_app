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

ActiveRecord::Schema[7.1].define(version: 2025_05_24_061725) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "postal_code"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clinics", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "director_name"
    t.string "homepage_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "data", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "postal_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address_street"
    t.string "building_name"
  end

  create_table "galleries", force: :cascade do |t|
    t.string "image_1"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_2"
    t.string "image_3"
  end

  create_table "medical_institutions", force: :cascade do |t|
    t.string "official_name"
    t.string "postal_code"
    t.string "address"
    t.string "fax"
    t.string "website"
    t.string "email"
    t.text "special_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "official_name_kana"
    t.string "phone_number"
    t.string "tag"
  end

  create_table "scraped_data", force: :cascade do |t|
    t.text "urls"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
