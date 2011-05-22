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

ActiveRecord::Schema.define(:version => 20110522064103) do

  create_table "feed_urls", :force => true do |t|
    t.string   "feed_url"
    t.string   "title"
    t.string   "site_url"
    t.boolean  "star",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", :force => true do |t|
    t.integer  "feed_url_id"
    t.string   "title"
    t.string   "author"
    t.string   "link"
    t.string   "site_link"
    t.string   "site_title"
    t.text     "content"
    t.datetime "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
