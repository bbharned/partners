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

ActiveRecord::Schema.define(version: 2022_02_09_172110) do

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

  create_table "answers", force: :cascade do |t|
    t.string "answer"
    t.integer "question_id"
    t.boolean "correct", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "calculators", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "certifications", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.float "version"
    t.date "date_earned"
    t.date "exp_date"
    t.boolean "active", default: true
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

  create_table "event_attendees", force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "checkedin", default: false
    t.string "lastname"
    t.boolean "canceled", default: false
  end

  create_table "event_categories", force: :cascade do |t|
    t.integer "event_id"
    t.integer "evtcategory_id"
  end

  create_table "event_tags", force: :cascade do |t|
    t.integer "event_id"
    t.integer "tag_id"
  end

  create_table "event_venues", force: :cascade do |t|
    t.integer "event_id"
    t.integer "venue_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "starttime"
    t.datetime "endtime"
    t.float "cost", default: 0.0
    t.integer "capacity"
    t.string "event_contact"
    t.string "event_email"
    t.string "event_host"
    t.string "event_phone"
    t.string "event_image"
    t.boolean "private"
    t.boolean "virtual"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "live", default: false
    t.string "viewer"
  end

  create_table "evtcategories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "image_link"
  end

  create_table "firmwares", force: :cascade do |t|
    t.decimal "version"
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
    t.boolean "sub_exchange", default: false
  end

  create_table "hardwares", force: :cascade do |t|
    t.integer "maker_id"
    t.integer "hwstatus_id"
    t.integer "hwtype_id"
    t.string "model"
    t.string "terminal_type"
    t.decimal "min_firmware"
    t.decimal "max_firmware"
    t.string "hardware_gpu_id"
    t.string "cpu"
    t.string "touch_interface"
    t.string "network_card"
    t.string "pci_network_id"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "priority", default: "e"
    t.string "video_chipset"
    t.index ["hwstatus_id"], name: "index_hardwares_on_hwstatus_id"
    t.index ["hwtype_id"], name: "index_hardwares_on_hwtype_id"
    t.index ["maker_id"], name: "index_hardwares_on_maker_id"
  end

  create_table "hwstatuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hwtypes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "makers", force: :cascade do |t|
    t.string "name"
    t.string "logo_path"
    t.string "url"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "qrcodes", force: :cascade do |t|
    t.string "content"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string "question"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quiz_categories", force: :cascade do |t|
    t.integer "quiz_id"
    t.integer "category_id"
  end

  create_table "quiz_questions", force: :cascade do |t|
    t.integer "quiz_id"
    t.integer "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quiz_videos", force: :cascade do |t|
    t.integer "quiz_id"
    t.integer "video_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quizzes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.integer "evtcategory_id"
    t.string "image_link"
    t.boolean "private", default: false
  end

  create_table "user_badges", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "productivity", default: false
    t.boolean "visualization", default: false
    t.boolean "security", default: false
    t.boolean "mobility", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_quizzes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "quiz_id"
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
    t.boolean "end_user", default: false
    t.boolean "integrator", default: false
    t.boolean "distributor", default: false
    t.boolean "oem", default: false
    t.boolean "needs_review", default: false
    t.string "lab_file"
    t.string "referred_by"
    t.boolean "cert_signup", default: false
    t.boolean "learn_signup", default: false
    t.boolean "hw_admin", default: false
    t.boolean "evt_admin", default: false
    t.string "street"
    t.string "street2"
    t.string "city"
    t.string "state"
    t.integer "zip"
    t.string "cell"
    t.string "carrier"
  end

  create_table "venues", force: :cascade do |t|
    t.string "name"
    t.string "street"
    t.string "city"
    t.string "state"
    t.integer "zipcode"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_link"
    t.text "description"
  end

  create_table "videos", force: :cascade do |t|
    t.string "name"
    t.string "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wrongs", force: :cascade do |t|
    t.integer "user_id"
    t.integer "quiz_id"
    t.integer "question_id"
    t.integer "answer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
