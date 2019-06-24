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

ActiveRecord::Schema.define(version: 2019_06_24_170553) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "credits", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "identity_id"
    t.uuid "ticket_id"
    t.integer "time"
    t.string "origin"
    t.string "stripe_charge_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id", "ticket_id"], name: "index_credits_on_identity_id_and_ticket_id"
    t.index ["identity_id"], name: "index_credits_on_identity_id"
    t.index ["origin"], name: "index_credits_on_origin"
    t.index ["stripe_charge_id"], name: "index_credits_on_stripe_charge_id"
    t.index ["ticket_id"], name: "index_credits_on_ticket_id"
    t.index ["time"], name: "index_credits_on_time"
  end

  create_table "event_call_to_actions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "body"
    t.string "label"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_files", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_messages", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_payment_authorizations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "body"
    t.integer "amount_in_cents"
    t.integer "fees_in_cents"
    t.datetime "authorized_at"
    t.datetime "charged_at"
    t.string "stripe_charge_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "identity_id"
    t.uuid "ticket_id"
    t.string "eventable_type"
    t.uuid "eventable_id"
    t.datetime "seen_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_events_on_identity_id"
    t.index ["ticket_id"], name: "index_events_on_ticket_id"
  end

  create_table "identities", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "role"
    t.string "email"
    t.string "encrypted_password"
    t.string "first_name"
    t.string "last_name"
    t.string "token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "recovery_sent_at"
    t.datetime "terms_accepted_at"
    t.string "confirmation_token"
    t.string "recovery_token"
    t.integer "credits_count", default: 0
    t.string "stripe_customer_id"
    t.string "stripe_card_id"
    t.datetime "email_opt_out_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mailbox"
    t.index ["confirmation_sent_at"], name: "index_identities_on_confirmation_sent_at"
    t.index ["confirmation_token"], name: "index_identities_on_confirmation_token"
    t.index ["confirmed_at"], name: "index_identities_on_confirmed_at"
    t.index ["credits_count"], name: "index_identities_on_credits_count"
    t.index ["email", "encrypted_password"], name: "index_identities_on_email_and_encrypted_password"
    t.index ["email"], name: "index_identities_on_email"
    t.index ["email_opt_out_at"], name: "index_identities_on_email_opt_out_at"
    t.index ["encrypted_password"], name: "index_identities_on_encrypted_password"
    t.index ["mailbox"], name: "index_identities_on_mailbox"
    t.index ["recovery_sent_at"], name: "index_identities_on_recovery_sent_at"
    t.index ["recovery_token"], name: "index_identities_on_recovery_token"
    t.index ["stripe_card_id"], name: "index_identities_on_stripe_card_id"
    t.index ["stripe_customer_id"], name: "index_identities_on_stripe_customer_id"
    t.index ["terms_accepted_at"], name: "index_identities_on_terms_accepted_at"
  end

  create_table "mailbox_mails", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "identity_id"
    t.uuid "ticket_id"
    t.string "direction"
    t.string "subject"
    t.string "from"
    t.string "to"
    t.string "body"
    t.jsonb "raw"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id", "direction"], name: "index_mailbox_mails_on_identity_id_and_direction"
    t.index ["identity_id", "ticket_id"], name: "index_mailbox_mails_on_identity_id_and_ticket_id"
    t.index ["identity_id"], name: "index_mailbox_mails_on_identity_id"
    t.index ["ticket_id", "direction"], name: "index_mailbox_mails_on_ticket_id_and_direction"
    t.index ["ticket_id"], name: "index_mailbox_mails_on_ticket_id"
  end

  create_table "tickets", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "identity_id"
    t.string "title"
    t.string "subject"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_tickets_on_identity_id"
    t.index ["status"], name: "index_tickets_on_status"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
