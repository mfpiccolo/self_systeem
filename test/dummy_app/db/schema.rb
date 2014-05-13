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

ActiveRecord::Schema.define(version: 20140425003311) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", force: true do |t|
    t.integer  "project_id", null: false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "areas", ["id"], name: "index_areas_on_id", using: :btree
  add_index "areas", ["project_id", "name"], name: "index_areas_on_project_id_and_name", unique: true, using: :btree
  add_index "areas", ["project_id"], name: "index_areas_on_project_id", using: :btree

  create_table "budget_items", force: true do |t|
    t.integer  "category_id",                     null: false
    t.integer  "project_id",                      null: false
    t.integer  "amount_cents",    default: 0,     null: false
    t.string   "amount_currency", default: "USD", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "area_id",                         null: false
  end

  add_index "budget_items", ["area_id"], name: "index_budget_items_on_area_id", using: :btree
  add_index "budget_items", ["category_id"], name: "index_budget_items_on_category_id", using: :btree
  add_index "budget_items", ["id"], name: "index_budget_items_on_id", using: :btree

  create_table "categories", force: true do |t|
    t.integer  "project_id", null: false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["id"], name: "index_categories_on_id", using: :btree
  add_index "categories", ["project_id", "name"], name: "index_categories_on_project_id_and_name", unique: true, using: :btree
  add_index "categories", ["project_id"], name: "index_categories_on_project_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "finish_id",  null: false
    t.integer  "user_id",    null: false
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["created_at"], name: "index_comments_on_created_at", using: :btree
  add_index "comments", ["finish_id"], name: "index_comments_on_finish_id", using: :btree
  add_index "comments", ["id"], name: "index_comments_on_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "deadlines", force: true do |t|
    t.integer  "area_id",                     null: false
    t.integer  "category_id",                 null: false
    t.integer  "project_id",                  null: false
    t.date     "due_date",                    null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "complete",    default: false
  end

  add_index "deadlines", ["area_id"], name: "index_deadlines_on_area_id", using: :btree
  add_index "deadlines", ["category_id"], name: "index_deadlines_on_category_id", using: :btree
  add_index "deadlines", ["id"], name: "index_deadlines_on_id", using: :btree

  create_table "default_areas", force: true do |t|
    t.integer  "organization_id", null: false
    t.string   "name",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "default_areas", ["id"], name: "index_default_areas_on_id", using: :btree
  add_index "default_areas", ["organization_id"], name: "index_default_areas_on_organization_id", using: :btree

  create_table "default_categories", force: true do |t|
    t.integer  "organization_id", null: false
    t.string   "name",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "default_categories", ["id"], name: "index_default_categories_on_id", using: :btree
  add_index "default_categories", ["organization_id"], name: "index_default_categories_on_organization_id", using: :btree

  create_table "finishes", force: true do |t|
    t.integer  "project_id",                     null: false
    t.integer  "area_id",                        null: false
    t.integer  "category_id",                    null: false
    t.string   "name"
    t.string   "location"
    t.string   "model"
    t.integer  "quantity",       default: 1,     null: false
    t.integer  "price_cents",    default: 0,     null: false
    t.string   "price_currency", default: "USD", null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "selected",       default: false
    t.integer  "selected_by_id"
    t.datetime "selected_at"
    t.integer  "comments_count", default: 0
  end

  add_index "finishes", ["id"], name: "index_finishes_on_id", using: :btree
  add_index "finishes", ["project_id", "name"], name: "index_finishes_on_project_id_and_name", unique: true, using: :btree
  add_index "finishes", ["project_id"], name: "index_finishes_on_project_id", using: :btree
  add_index "finishes", ["selected_by_id"], name: "index_finishes_on_selected_by_id", using: :btree

  create_table "organization_users", force: true do |t|
    t.integer  "organization_id", null: false
    t.integer  "user_id",         null: false
    t.string   "role",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organization_users", ["id"], name: "index_organization_users_on_id", using: :btree
  add_index "organization_users", ["organization_id", "user_id"], name: "index_organization_users_on_organization_id_and_user_id", unique: true, using: :btree
  add_index "organization_users", ["organization_id"], name: "index_organization_users_on_organization_id", using: :btree
  add_index "organization_users", ["user_id"], name: "index_organization_users_on_user_id", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name",        null: false
    t.string   "logo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "location"
    t.text     "description"
  end

  add_index "organizations", ["id"], name: "index_organizations_on_id", using: :btree
  add_index "organizations", ["name"], name: "index_organizations_on_name", unique: true, using: :btree

  create_table "project_attachments", force: true do |t|
    t.integer  "project_id",   null: false
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "finish_id"
    t.string   "content_type"
  end

  add_index "project_attachments", ["finish_id"], name: "index_project_attachments_on_finish_id", using: :btree
  add_index "project_attachments", ["id"], name: "index_project_attachments_on_id", using: :btree
  add_index "project_attachments", ["project_id"], name: "index_project_attachments_on_project_id", using: :btree

  create_table "project_organizations", force: true do |t|
    t.integer  "project_id",      null: false
    t.integer  "organization_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_organizations", ["id"], name: "index_project_organizations_on_id", using: :btree
  add_index "project_organizations", ["organization_id"], name: "index_project_organizations_on_organization_id", using: :btree
  add_index "project_organizations", ["project_id", "organization_id"], name: "index_project_organizations_on_project_id_and_organization_id", unique: true, using: :btree
  add_index "project_organizations", ["project_id"], name: "index_project_organizations_on_project_id", using: :btree

  create_table "project_users", force: true do |t|
    t.integer  "project_id", null: false
    t.integer  "user_id",    null: false
    t.string   "role",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_users", ["id"], name: "index_project_users_on_id", using: :btree
  add_index "project_users", ["project_id", "user_id"], name: "index_project_users_on_project_id_and_user_id", unique: true, using: :btree
  add_index "project_users", ["project_id"], name: "index_project_users_on_project_id", using: :btree
  add_index "project_users", ["user_id"], name: "index_project_users_on_user_id", using: :btree

  create_table "projects", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "location"
    t.integer  "total_budget_cents",             default: 0
    t.string   "total_budget_currency",          default: "USD", null: false
    t.integer  "selected_total_amount_cents",    default: 0,     null: false
    t.string   "selected_total_amount_currency", default: "USD", null: false
    t.datetime "deadline_notification_sent_at"
  end

  add_index "projects", ["id"], name: "index_projects_on_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "invitation_token"
    t.string   "name",                                null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "areas", "projects", name: "areas_project_id_fk"

  add_foreign_key "budget_items", "areas", name: "budget_items_area_id_fk"
  add_foreign_key "budget_items", "categories", name: "budget_items_category_id_fk"
  add_foreign_key "budget_items", "projects", name: "budget_items_project_id_fk"

  add_foreign_key "categories", "projects", name: "categories_project_id_fk"

  add_foreign_key "comments", "finishes", name: "comments_finish_id_fk"
  add_foreign_key "comments", "users", name: "comments_user_id_fk"

  add_foreign_key "deadlines", "areas", name: "deadlines_area_id_fk"
  add_foreign_key "deadlines", "categories", name: "deadlines_category_id_fk"
  add_foreign_key "deadlines", "projects", name: "deadlines_project_id_fk"

  add_foreign_key "default_areas", "organizations", name: "default_areas_organization_id_fk"

  add_foreign_key "default_categories", "organizations", name: "default_categories_organization_id_fk"

  add_foreign_key "finishes", "areas", name: "finishes_area_id_fk"
  add_foreign_key "finishes", "categories", name: "finishes_category_id_fk"
  add_foreign_key "finishes", "projects", name: "finishes_project_id_fk"
  add_foreign_key "finishes", "users", name: "finishes_selected_by_id_fk", column: "selected_by_id"

  add_foreign_key "organization_users", "organizations", name: "organization_users_organization_id_fk"
  add_foreign_key "organization_users", "users", name: "organization_users_user_id_fk"

  add_foreign_key "project_attachments", "finishes", name: "project_attachments_finish_id_fk"
  add_foreign_key "project_attachments", "projects", name: "project_attachments_project_id_fk"

  add_foreign_key "project_organizations", "organizations", name: "project_organizations_organization_id_fk"
  add_foreign_key "project_organizations", "projects", name: "project_organizations_project_id_fk"

  add_foreign_key "project_users", "projects", name: "project_users_project_id_fk"
  add_foreign_key "project_users", "users", name: "project_users_user_id_fk"

end
