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

ActiveRecord::Schema[8.0].define(version: 2025_08_18_042755) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "advances", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.decimal "amount"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", default: 1, null: false
    t.string "reason"
    t.index ["employee_id"], name: "index_advances_on_employee_id"
    t.index ["user_id"], name: "index_advances_on_user_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "full_name"
    t.decimal "daily_pay"
    t.string "phone"
    t.string "national_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "status", default: true, null: false
    t.integer "user_id", default: 1, null: false
    t.string "job_category", default: "1", null: false
    t.index ["user_id"], name: "index_employees_on_user_id"
  end

  create_table "loan_repayments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "loan_id", null: false
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["loan_id"], name: "index_loan_repayments_on_loan_id"
    t.index ["user_id"], name: "index_loan_repayments_on_user_id"
  end

  create_table "loans", force: :cascade do |t|
    t.integer "member_id", null: false
    t.decimal "available_amount"
    t.decimal "amount"
    t.string "payment_period_months"
    t.decimal "repayment_amount_per_month"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["member_id"], name: "index_loans_on_member_id"
    t.index ["user_id"], name: "index_loans_on_user_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "membership_number"
    t.string "name"
    t.string "id_number"
    t.string "phone_number"
    t.string "email"
    t.date "join_date"
    t.boolean "status", default: true
    t.string "next_of_kin_name"
    t.string "next_of_kin_contact"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "next_of_kin_relationship"
    t.decimal "monthly_contribution"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "savings", force: :cascade do |t|
    t.integer "member_id", null: false
    t.decimal "amount"
    t.string "deposit_type"
    t.date "month"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_savings_on_member_id"
    t.index ["user_id"], name: "index_savings_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.boolean "sign_ups_enabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "role"
    t.boolean "access_granted"
    t.boolean "status", default: true
    t.datetime "last_seen_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "advances", "employees"
  add_foreign_key "advances", "users"
  add_foreign_key "employees", "users"
  add_foreign_key "loan_repayments", "loans"
  add_foreign_key "loan_repayments", "users"
  add_foreign_key "loans", "members"
  add_foreign_key "loans", "users"
  add_foreign_key "members", "users"
  add_foreign_key "savings", "members"
  add_foreign_key "savings", "users"
end
