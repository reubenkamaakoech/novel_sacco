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

ActiveRecord::Schema[8.0].define(version: 2025_07_13_142359) do
  create_table "advances", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.decimal "amount"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", default: 1, null: false
    t.index ["employee_id"], name: "index_advances_on_employee_id"
    t.index ["user_id"], name: "index_advances_on_user_id"
  end

  create_table "attendances", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.integer "site_id"
    t.date "work_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", default: 1, null: false
    t.index ["employee_id", "work_date"], name: "index_attendances_on_employee_id_and_work_date", unique: true
    t.index ["employee_id"], name: "index_attendances_on_employee_id"
    t.index ["site_id"], name: "index_attendances_on_site_id"
    t.index ["user_id"], name: "index_attendances_on_user_id"
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
    t.index ["user_id"], name: "index_employees_on_user_id"
  end

  create_table "payrolls", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.string "period"
    t.integer "worked_days"
    t.decimal "total_pay"
    t.decimal "advance"
    t.decimal "payable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", default: 1, null: false
    t.index ["employee_id"], name: "index_payrolls_on_employee_id"
    t.index ["user_id"], name: "index_payrolls_on_user_id"
  end

# Could not dump table "sites" because of following StandardError
#   Unknown type '' for column 'labour_cost'


  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "advances", "employees"
  add_foreign_key "advances", "users"
  add_foreign_key "attendances", "employees"
  add_foreign_key "attendances", "sites"
  add_foreign_key "attendances", "users"
  add_foreign_key "employees", "users"
  add_foreign_key "payrolls", "employees"
  add_foreign_key "payrolls", "users"
  add_foreign_key "sites", "users"
end
