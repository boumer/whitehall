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

ActiveRecord::Schema.define(:version => 20110929105024) do

  create_table "documents", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "editions", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "author_id"
    t.boolean  "submitted",     :default => false
    t.integer  "lock_version",  :default => 0
    t.integer  "document_id"
    t.string   "state",         :default => "draft",  :null => false
    t.string   "attachment"
    t.string   "document_type", :default => "Policy", :null => false
  end

  create_table "fact_check_requests", :force => true do |t|
    t.integer  "edition_id"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email_address"
    t.text     "comments"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "departmental_editor", :default => false
  end

end
