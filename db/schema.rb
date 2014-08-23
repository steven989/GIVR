# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140821231369) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "application_statuses", force: true do |t|
    t.integer  "application_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "applications", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "status"
    t.string   "resume"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "notification_view_flag"
    t.text     "message"
    t.integer  "hours"
    t.integer  "rating_for_professional"
    t.string   "work_again"
    t.text     "comments_for_professional"
    t.datetime "application_date"
    t.date     "est_completion_date"
    t.text     "open_questions"
    t.text     "required_resources"
    t.date     "unapproved_status_view_date"
    t.date     "in_progress_date"
    t.date     "complete_date"
  end

  create_table "authentications", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "category"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_users", force: true do |t|
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "causes", force: true do |t|
    t.string   "cause"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "causes_users", force: true do |t|
    t.integer  "cause_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", force: true do |t|
    t.string   "company_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: true do |t|
    t.string   "location"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations_users", force: true do |t|
    t.integer  "location_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monologue_posts", force: true do |t|
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "title"
    t.text     "content"
    t.string   "url"
    t.datetime "published_at"
  end

  add_index "monologue_posts", ["url"], name: "index_monologue_posts_on_url", unique: true, using: :btree

  create_table "monologue_taggings", force: true do |t|
    t.integer "post_id"
    t.integer "tag_id"
  end

  add_index "monologue_taggings", ["post_id"], name: "index_monologue_taggings_on_post_id", using: :btree
  add_index "monologue_taggings", ["tag_id"], name: "index_monologue_taggings_on_tag_id", using: :btree

  create_table "monologue_tags", force: true do |t|
    t.string "name"
  end

  add_index "monologue_tags", ["name"], name: "index_monologue_tags_on_name", using: :btree

  create_table "monologue_users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_statuses", force: true do |t|
    t.integer  "project_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_views", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "view_start_time"
    t.datetime "view_end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "browser"
    t.string   "ip_address"
  end

  create_table "projects", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "category_id"
    t.integer  "cause_id"
    t.integer  "location_id"
    t.string   "status"
    t.integer  "number_of_positions"
    t.text     "deliverable"
    t.string   "overseer"
    t.text     "why_we_need_this"
    t.text     "perks"
    t.text     "requirements"
    t.datetime "approval_date"
    t.string   "hide_name"
    t.text     "how_output_will_be_used"
    t.date     "required_date"
  end

  create_table "users", force: true do |t|
    t.string   "email",                           null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.string   "resume"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "logo"
    t.string   "org_name"
    t.integer  "cause_id"
    t.text     "mission"
    t.string   "address"
    t.string   "city"
    t.string   "postal_code"
    t.string   "website"
    t.string   "contact_first_name"
    t.string   "contact_last_name"
    t.string   "phone"
    t.string   "extension"
    t.string   "fax"
    t.integer  "years_of_experience"
    t.integer  "organization_size"
    t.string   "resume_quick_look"
    t.text     "description"
    t.string   "employee_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree

end
