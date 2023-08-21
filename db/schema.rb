# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_08_21_165544) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "vector"

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string "email"
    t.string "company_name"
    t.string "number_of_employees"
    t.string "database_support"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dataqueries", force: :cascade do |t|
    t.string "name"
    t.text "query"
    t.integer "datasource_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.string "request_method"
    t.json "request_header"
    t.json "request_body"
    t.datetime "deleted_at"
  end

  create_table "datasources", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "datasource_type"
    t.string "host"
    t.string "port"
    t.string "database_name"
    t.string "database_username"
    t.string "database_password"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "swagger_url"
    t.string "api_key"
    t.datetime "deleted_at"
    t.index ["company_id"], name: "index_datasources_on_company_id"
  end

  create_table "dataview_dataqueries", force: :cascade do |t|
    t.integer "height"
    t.integer "width"
    t.integer "x_position"
    t.integer "y_position"
    t.bigint "dataview_id", null: false
    t.bigint "dataquery_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dataquery_id"], name: "index_dataview_dataqueries_on_dataquery_id"
    t.index ["dataview_id"], name: "index_dataview_dataqueries_on_dataview_id"
  end

  create_table "dataviews", force: :cascade do |t|
    t.string "name"
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "dataviews_dataqueries", force: :cascade do |t|
    t.bigint "dataview_id", null: false
    t.bigint "dataquery_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "height"
    t.integer "width"
    t.integer "x_position"
    t.integer "y_position"
    t.index ["dataquery_id"], name: "index_dataviews_dataqueries_on_dataquery_id"
    t.index ["dataview_id"], name: "index_dataviews_dataqueries_on_dataview_id"
  end

# Could not dump table "documents_items" because of following StandardError
#   Unknown type 'vector(1536)' for column 'embedding'

  create_table "mailer_schedulers", force: :cascade do |t|
    t.string "name"
    t.bigint "dataview_id", null: false
    t.bigint "user_id", null: false
    t.string "send_time"
    t.string "recipient"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dataview_id"], name: "index_mailer_schedulers_on_dataview_id"
    t.index ["user_id"], name: "index_mailer_schedulers_on_user_id"
  end

  create_table "prompts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "datasource_id", null: false
    t.text "content"
    t.text "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "requestdetail"
    t.index ["datasource_id"], name: "index_prompts_on_datasource_id"
    t.index ["user_id"], name: "index_prompts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.boolean "is_admin", default: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "dataview_dataqueries", "dataqueries"
  add_foreign_key "dataview_dataqueries", "dataviews"
  add_foreign_key "dataviews_dataqueries", "dataqueries"
  add_foreign_key "dataviews_dataqueries", "dataviews"
  add_foreign_key "mailer_schedulers", "dataviews"
  add_foreign_key "mailer_schedulers", "users"
  add_foreign_key "prompts", "datasources"
  add_foreign_key "prompts", "users"
  add_foreign_key "users", "companies"
end
