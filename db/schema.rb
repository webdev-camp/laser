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

ActiveRecord::Schema.define(version: 20161013153222) do

  create_table "comments", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "laser_gem_id"
    t.integer  "user_id"
  end

  create_table "gem_dependencies", force: :cascade do |t|
    t.integer  "laser_gem_id"
    t.integer  "dependency_id"
    t.string   "version"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["dependency_id"], name: "index_gem_dependencies_on_dependency_id"
    t.index ["laser_gem_id", "dependency_id"], name: "index_gem_dependencies_on_laser_gem_id_and_dependency_id", unique: true
    t.index ["laser_gem_id"], name: "index_gem_dependencies_on_laser_gem_id"
  end

  create_table "gem_gits", force: :cascade do |t|
    t.string   "name"
    t.string   "homepage"
    t.date     "last_commit"
    t.integer  "forks_count"
    t.integer  "stargazers_count"
    t.integer  "watchers_count"
    t.integer  "open_issues_count"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "laser_gem_id"
  end

  create_table "gem_specs", force: :cascade do |t|
    t.string   "name"
    t.text     "info"
    t.string   "current_version"
    t.integer  "current_version_downloads"
    t.integer  "total_downloads"
    t.string   "rubygem_uri"
    t.string   "documentation_uri"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "laser_gem_id"
  end

  create_table "laser_gems", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "owners", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "email"
    t.integer  "laser_gem_id"
    t.index ["laser_gem_id"], name: "index_owners_on_laser_gem_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
