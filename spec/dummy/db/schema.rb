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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130529111800) do

  create_table "gifts", :force => true do |t|
    t.string   "code"
    t.integer  "amount"
    t.boolean  "reusable",   :default => false
    t.datetime "expires_at"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "products", :force => true do |t|
    t.string   "name"
    t.integer  "points"
    t.integer  "owner_id"
    t.integer  "buyer_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "products", ["buyer_id"], :name => "index_products_on_buyer_id"
  add_index "products", ["owner_id"], :name => "index_products_on_owner_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email",      :default => "", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "vouchers", :force => true do |t|
    t.string   "code"
    t.integer  "amount"
    t.boolean  "reusable",   :default => false
    t.datetime "expires_at"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

end
