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

ActiveRecord::Schema.define(version: 2020_09_29_172149) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "calculators", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "currencies", force: :cascade do |t|
    t.string "name"
    t.string "symbol"
    t.float "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "downloads", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flexforwards", force: :cascade do |t|
    t.integer "user_id"
    t.integer "currency_id"
    t.string "name"
    t.boolean "mirrored", default: false
    t.boolean "red_exchange", default: false
    t.integer "ex_serv_sup", default: 0
    t.integer "ex_serv_nosup", default: 0
    t.integer "ex_serv_nosup_years", default: 0
    t.integer "ex_site_sup", default: 0
    t.integer "ex_site_nosup", default: 0
    t.integer "ex_site_nosup_years", default: 0
    t.integer "ex_simp_sup", default: 0
    t.integer "ex_simp_nosup", default: 0
    t.integer "ex_simp_nosup_years", default: 0
    t.integer "ex_red_sup", default: 0
    t.integer "ex_red_nosup", default: 0
    t.integer "ex_red_nosup_years", default: 0
    t.integer "tr_serv", default: 0
    t.decimal "tr_pr_serv", precision: 10, scale: 2, default: "0.0"
    t.decimal "tr_cred_serv", precision: 10, scale: 2, default: "0.0"
    t.integer "tr_site", default: 0
    t.decimal "tr_pr_site", precision: 10, scale: 2, default: "0.0"
    t.decimal "tr_cred_site", precision: 10, scale: 2, default: "0.0"
    t.integer "tr_simp", default: 0
    t.decimal "tr_pr_simp", precision: 10, scale: 2, default: "0.0"
    t.decimal "tr_cred_simp", precision: 10, scale: 2, default: "0.0"
    t.integer "tr_red", default: 0
    t.decimal "tr_pr_red", precision: 10, scale: 2, default: "0.0"
    t.decimal "tr_cred_red", precision: 10, scale: 2, default: "0.0"
    t.integer "new_simp", default: 0
    t.decimal "new_pr_simp", precision: 10, scale: 2, default: "0.0"
    t.integer "new_red", default: 0
    t.decimal "new_pr_red", precision: 10, scale: 2, default: "0.0"
    t.integer "total_terms", default: 0
    t.decimal "tr_pr_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "tr_cred_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "total_tr_cost", precision: 10, scale: 2, default: "0.0"
    t.decimal "total_maint", precision: 10, scale: 2, default: "0.0"
    t.date "sm_exp"
    t.decimal "total_quote", precision: 10, scale: 2, default: "0.0"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "email"
    t.string "company"
    t.string "prttype"
    t.string "silevel"
    t.string "channel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.boolean "active", default: true
    t.boolean "admin", default: false
    t.string "continent"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.datetime "lastlogin"
    t.date "certdate"
    t.date "certexpire"
  end

end
