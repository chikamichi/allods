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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110219180438) do

  create_table "admins", :force => true do |t|
    t.string   "email",                             :default => "", :null => false
    t.string   "encrypted_password", :limit => 128, :default => "", :null => false
    t.string   "password_salt",                     :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "characters", :force => true do |t|
    t.string   "nickname",   :null => false
    t.integer  "level",      :null => false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "characters", ["user_id"], :name => "index_characters_on_user_id"

  create_table "loot_machines", :force => true do |t|
    t.string "title",       :null => false
    t.text   "description"
    t.string "metadata"
  end

  create_table "loot_statuses", :force => true do |t|
    t.integer  "character_id"
    t.integer  "loot_machine_id"
    t.string   "status",          :default => "need", :null => false
    t.integer  "need",            :default => 0,      :null => false
    t.integer  "greed",           :default => 0,      :null => false
    t.integer  "loyalty",         :default => 0,      :null => false
    t.string   "score",           :default => "0",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "loot_statuses", ["character_id"], :name => "index_loot_statuses_on_character_id"
  add_index "loot_statuses", ["loot_machine_id"], :name => "index_loot_statuses_on_loot_machine_id"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",       :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",       :null => false
    t.string   "password_salt",                       :default => "",       :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authentication_token"
    t.string   "access_level",                        :default => "member"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
