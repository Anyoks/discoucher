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

ActiveRecord::Schema.define(version: 20190417062106) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "pgcrypto"

  create_table "admins", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
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
    t.string "first_name"
    t.string "last_name"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "books", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code"
    t.string "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "registered", default: false, null: false
    t.index ["code"], name: "index_books_on_code", unique: true
  end

  create_table "details", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "book_id"
    t.uuid "establishment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_details_on_book_id"
    t.index ["establishment_id"], name: "index_details_on_establishment_id"
  end

  create_table "establishment_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "available", default: false, null: false
  end

  create_table "establishments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "area"
    t.string "location"
    t.string "phone"
    t.string "address"
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "book_id"
    t.integer "establishment_type_id"
    t.text "description"
    t.string "working_hours"
    t.string "email"
    t.string "website"
    t.string "social_media"
    t.index ["book_id"], name: "index_establishments_on_book_id"
    t.index ["establishment_type_id"], name: "index_establishments_on_establishment_type_id"
  end

  create_table "failed_messages", id: :serial, force: :cascade do |t|
    t.string "message"
    t.string "phone_number"
  end

  create_table "failed_payment_responses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "MerchantRequestID"
    t.string "CheckoutRequestID"
    t.string "ResultCode"
    t.string "ResultDescription"
    t.uuid "payment_request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "failed_redemptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "establishment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["establishment_id"], name: "index_failed_redemptions_on_establishment_id"
    t.index ["user_id"], name: "index_failed_redemptions_on_user_id"
  end

  create_table "favourites", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "voucher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_favourites_on_user_id"
    t.index ["voucher_id"], name: "index_favourites_on_voucher_id"
  end

  create_table "payment_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "MerchantRequestID"
    t.string "CheckoutRequestID"
    t.string "ResponseCode"
    t.string "ResponseDescription"
    t.string "CustomerMessage"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_responses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "MerchantRequestID"
    t.string "CheckoutRequestID"
    t.string "ResultCode"
    t.string "ResultDescription"
    t.string "Amount"
    t.string "MpesaReceiptNumber"
    t.string "Balance"
    t.datetime "TransactionDate"
    t.string "PhoneNumber"
    t.uuid "payment_request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "book_code", default: "test", null: false
  end

  create_table "pictures", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "description"
    t.string "image"
    t.uuid "establishment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "register_books", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "email"
    t.string "book_code"
    t.uuid "book_id"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_register_books_on_book_id", unique: true
    t.index ["user_id"], name: "index_register_books_on_user_id"
  end

  create_table "reviews", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "comment"
    t.float "rating"
    t.uuid "user_id"
    t.uuid "voucher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_reviews_on_user_id"
    t.index ["voucher_id"], name: "index_reviews_on_voucher_id"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "sms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "message"
    t.string "voucher_code"
    t.string "book_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "status"
    t.string "phone_number"
  end

  create_table "tagpics", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tag_id"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_tagpics_on_tag_id"
  end

  create_table "tags", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "tags_vouchers", id: false, force: :cascade do |t|
    t.uuid "voucher_id"
    t.uuid "tag_id"
    t.index ["tag_id"], name: "index_tags_vouchers_on_tag_id"
    t.index ["voucher_id"], name: "index_tags_vouchers_on_voucher_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
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
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider", default: "", null: false
    t.string "uid", default: "", null: false
    t.boolean "allow_password_change", default: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.json "tokens"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "visits", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "register_book_id"
    t.uuid "user_id"
    t.uuid "establishment_id"
    t.uuid "voucher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["establishment_id"], name: "index_visits_on_establishment_id"
    t.index ["register_book_id"], name: "index_visits_on_register_book_id"
    t.index ["user_id"], name: "index_visits_on_user_id"
    t.index ["voucher_id"], name: "index_visits_on_voucher_id"
  end

  create_table "vouchers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code"
    t.text "description"
    t.text "condition"
    t.string "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "establishment_id"
    t.boolean "redeem_status", default: false
    t.index ["code"], name: "index_vouchers_on_code", unique: true
    t.index ["establishment_id"], name: "index_vouchers_on_establishment_id"
  end

end
