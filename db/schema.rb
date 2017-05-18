# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170517050228) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "intarray"

  create_table "activities", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.hstore "log"
    t.string "controller"
    t.string "action"
    t.string "ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "auth_tokens", id: :serial, force: :cascade do |t|
    t.string "val"
    t.datetime "expire_at"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["val"], name: "index_auth_tokens_on_val"
  end

  create_table "banners", force: :cascade do |t|
    t.string "image"
    t.string "title"
    t.string "link"
    t.integer "advert_place_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "currencies", id: :serial, force: :cascade do |t|
    t.string "name"
    t.float "val"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["val"], name: "index_currencies_on_val"
  end

  create_table "groups", id: :serial, force: :cascade do |t|
    t.string "cid"
    t.string "title"
    t.string "parent_cid"
    t.string "ancestry"
    t.integer "position"
    t.string "site_title"
    t.string "sort_type"
    t.boolean "disabled", default: false
    t.integer "importsession_id"
    t.datetime "last_new_item"
    t.integer "items_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "menu_columns"
  end

  create_table "imports", id: :serial, force: :cascade do |t|
    t.string "filename"
    t.string "status"
    t.integer "importsession_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "importsessions", id: :serial, force: :cascade do |t|
    t.string "cookie"
    t.string "status"
    t.string "exchange_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", id: :serial, force: :cascade do |t|
    t.string "cid"
    t.string "article"
    t.string "title"
    t.string "full_title"
    t.string "group_cid"
    t.integer "group_id"
    t.string "image"
    t.hstore "properties"
    t.text "text"
    t.integer "qty", default: 0
    t.integer "importsession_id"
    t.integer "position"
    t.string "brand"
    t.hstore "label"
    t.string "certificate"
    t.string "cross", array: true
    t.jsonb "bids", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.datetime "formed"
    t.string "comment"
    t.float "total", default: 0.0
    t.jsonb "order_list", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "price_types", id: :serial, force: :cascade do |t|
    t.string "cid"
    t.string "title"
    t.string "currency_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "role", default: "user"
    t.string "inn"
    t.string "person"
    t.string "city"
    t.string "legal_address"
    t.string "actual_address"
    t.string "kpp"
    t.string "bank_name"
    t.string "curr_account"
    t.string "corr_account"
    t.string "bik"
    t.string "phone"
    t.text "note"
    t.integer "activities_count", default: 0
    t.integer "orders_count", default: 0
    t.datetime "last_activity_at"
    t.string "ogrn"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
