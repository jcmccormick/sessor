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

ActiveRecord::Schema.define(version: 20151123231801) do

  create_table "admins_reports", id: false, force: :cascade do |t|
    t.integer "admin_id",  limit: 4
    t.integer "report_id", limit: 4
  end

  add_index "admins_reports", ["admin_id"], name: "index_admins_reports_on_admin_id", using: :btree
  add_index "admins_reports", ["report_id"], name: "index_admins_reports_on_report_id", using: :btree

  create_table "admins_templates", id: false, force: :cascade do |t|
    t.integer "admin_id",    limit: 4
    t.integer "template_id", limit: 4
  end

  add_index "admins_templates", ["admin_id"], name: "index_admins_templates_on_admin_id", using: :btree
  add_index "admins_templates", ["template_id"], name: "index_admins_templates_on_template_id", using: :btree

  create_table "authorizations", force: :cascade do |t|
    t.string   "provider",   limit: 255
    t.string   "uid",        limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "token",      limit: 255
    t.string   "secret",     limit: 255
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "email",      limit: 255
    t.text     "message",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "fields", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "fieldtype",     limit: 255
    t.boolean  "required"
    t.boolean  "disabled"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "column_id",     limit: 4
    t.string   "glyphicon",     limit: 255
    t.integer  "section_id",    limit: 4
    t.integer  "template_id",   limit: 4
    t.text     "options",       limit: 65535
    t.integer  "column_order",  limit: 4
    t.text     "default_value", limit: 65535
    t.string   "placeholder",   limit: 255
    t.string   "tooltip",       limit: 255
    t.text     "o",             limit: 65535
  end

  add_index "fields", ["column_id"], name: "index_fields_on_column_id", using: :btree
  add_index "fields", ["template_id"], name: "index_fields_on_template_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "owner",      limit: 255
    t.text     "members",    limit: 65535
    t.text     "templates",  limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "newsletters", force: :cascade do |t|
    t.text     "email",      limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "reports", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.text     "submission",     limit: 65535
    t.text     "response",       limit: 65535
    t.boolean  "active"
    t.string   "location",       limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "allow_title"
    t.text     "template_order", limit: 65535
  end

  create_table "reports_templates", id: false, force: :cascade do |t|
    t.integer "report_id",   limit: 4
    t.integer "template_id", limit: 4
  end

  add_index "reports_templates", ["report_id"], name: "index_reports_templates_on_report_id", using: :btree
  add_index "reports_templates", ["template_id"], name: "index_reports_templates_on_template_id", using: :btree

  create_table "reports_users", id: false, force: :cascade do |t|
    t.integer "user_id",   limit: 4
    t.integer "report_id", limit: 4
  end

  add_index "reports_users", ["report_id"], name: "index_reports_users_on_report_id", using: :btree
  add_index "reports_users", ["user_id"], name: "index_reports_users_on_user_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "templates", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.boolean  "private_world"
    t.boolean  "private_group"
    t.integer  "group_id",      limit: 4
    t.boolean  "group_edit"
    t.text     "group_editors", limit: 65535
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "draft"
    t.text     "sections",      limit: 65535
    t.text     "columns",       limit: 65535
  end

  create_table "templates_users", id: false, force: :cascade do |t|
    t.integer "user_id",     limit: 4
    t.integer "template_id", limit: 4
  end

  add_index "templates_users", ["template_id"], name: "index_templates_users_on_template_id", using: :btree
  add_index "templates_users", ["user_id"], name: "index_templates_users_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "provider",               limit: 255,                null: false
    t.string   "uid",                    limit: 255,   default: "", null: false
    t.string   "encrypted_password",     limit: 255,   default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.string   "name",                   limit: 255
    t.string   "nickname",               limit: 255
    t.string   "image",                  limit: 255
    t.string   "email",                  limit: 255
    t.text     "tokens",                 limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id",               limit: 4
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["group_id"], name: "index_users_on_group_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

  create_table "values", force: :cascade do |t|
    t.text     "input",      limit: 65535
    t.integer  "field_id",   limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "report_id",  limit: 4
  end

  add_index "values", ["field_id"], name: "index_values_on_field_id", using: :btree
  add_index "values", ["report_id"], name: "index_values_on_report_id", using: :btree

end
