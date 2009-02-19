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

ActiveRecord::Schema.define(:version => 20090218142316) do

  create_table "download_requests", :force => true do |t|
    t.string   "url"
    t.string   "description"
    t.integer  "created_by_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "downloads", :force => true do |t|
    t.string   "url"
    t.string   "description"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "featured_projects", :force => true do |t|
    t.integer  "project_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
  end

  create_table "forums", :force => true do |t|
    t.integer  "project_id"
    t.boolean  "use_internal"
    t.string   "external_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "phpbb_forum_id"
  end

  create_table "issue_trackers", :force => true do |t|
    t.integer  "project_id"
    t.boolean  "use_internal"
    t.string   "external_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_items", :force => true do |t|
    t.string   "title"
    t.text     "contents"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_groups", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.integer  "phpbb_group_id"
  end

  create_table "project_maturities", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_news_items", :force => true do |t|
    t.integer  "project_id"
    t.string   "title"
    t.text     "contents"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_statuses", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "shortname"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.integer  "project_status_id"
    t.integer  "project_maturity_id"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.integer  "project_category_id"
    t.boolean  "is_private"
    t.datetime "accepted_terms_at"
  end

  create_table "prospective_project_members", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment"
  end

  create_table "repositories", :force => true do |t|
    t.integer  "project_id"
    t.boolean  "use_internal"
    t.string   "external_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope",          :limit => 40
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "scope", "sequence"], :name => "index_slugs_on_name_and_sluggable_type_and_scope_and_sequence", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string  "login"
    t.integer "phpbb_user_id"
  end

  create_table "web_dav_locations", :force => true do |t|
    t.integer  "project_id"
    t.boolean  "is_active"
    t.boolean  "use_internal"
    t.string   "external_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wiki_page_attachment_downloads", :force => true do |t|
    t.integer  "wiki_page_attachment_id"
    t.integer  "downloaded_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wiki_page_attachments", :force => true do |t|
    t.integer  "wiki_page_id"
    t.string   "attached_file_file_name"
    t.string   "attached_file_content_type"
    t.integer  "attached_file_file_size"
    t.datetime "attached_file_updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "track_downloads"
    t.boolean  "include_in_project_homepage_download_stats"
  end

  create_table "wiki_page_versions", :force => true do |t|
    t.integer  "wiki_page_id"
    t.integer  "version"
    t.string   "slug"
    t.text     "body"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "updated_at"
    t.integer  "wiki_id"
  end

  create_table "wiki_pages", :force => true do |t|
    t.string   "slug"
    t.text     "body"
    t.integer  "version"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "wiki_id"
  end

  create_table "wikis", :force => true do |t|
    t.integer  "project_id"
    t.boolean  "use_internal"
    t.string   "external_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
