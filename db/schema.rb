# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 15) do

  create_table "categories", :force => true do |t|
    t.string "cat_name"
    t.string "desc"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment_text"
  end

  create_table "posts", :force => true do |t|
    t.string   "song"
    t.string   "artist"
    t.string   "album"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "rating"
    t.integer  "rating_count"
    t.text     "comment"
    t.string   "filename"
    t.integer  "category"
  end

  create_table "ratings", :force => true do |t|
    t.integer "user_id"
    t.integer "post_id"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.date     "last_post"
    t.boolean  "activated",                               :default => false, :null => false
    t.string   "digest"
    t.boolean  "remind_me",                               :default => false, :null => false
    t.boolean  "reminded",                                :default => false, :null => false
    t.datetime "last_login"
  end

end
