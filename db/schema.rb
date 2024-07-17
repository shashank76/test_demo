# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_07_17_045855) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "building_custom_field_values", force: :cascade do |t|
    t.bigint "building_id", null: false
    t.bigint "client_custom_field_id", null: false
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["building_id"], name: "index_building_custom_field_values_on_building_id"
    t.index ["client_custom_field_id"], name: "index_building_custom_field_values_on_client_custom_field_id"
  end

  create_table "buildings", force: :cascade do |t|
    t.string "address", null: false
    t.string "state", null: false
    t.string "zip", null: false
    t.bigint "client_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_buildings_on_client_id"
  end

  create_table "client_custom_fields", force: :cascade do |t|
    t.string "field_name", null: false
    t.integer "field_type", default: 0, null: false
    t.string "field_values", default: [], array: true
    t.bigint "client_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_client_custom_fields_on_client_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "building_custom_field_values", "buildings"
  add_foreign_key "building_custom_field_values", "client_custom_fields"
  add_foreign_key "buildings", "clients"
  add_foreign_key "client_custom_fields", "clients"
end
