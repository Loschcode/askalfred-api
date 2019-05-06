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

ActiveRecord::Schema.define(version: 2019_05_06_192131) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "credits", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "identity_id"
    t.string "ticket_id"
    t.integer "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id", "ticket_id"], name: "index_credits_on_identity_id_and_ticket_id"
    t.index ["identity_id"], name: "index_credits_on_identity_id"
    t.index ["ticket_id"], name: "index_credits_on_ticket_id"
    t.index ["time"], name: "index_credits_on_time"
  end

  create_table "event_files", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_messages", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "identity_id"
    t.string "ticket_id"
    t.string "eventable_type"
    t.string "eventable_id"
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
    t.string "confirmation_token"
    t.string "recovery_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_sent_at"], name: "index_identities_on_confirmation_sent_at"
    t.index ["confirmation_token"], name: "index_identities_on_confirmation_token"
    t.index ["confirmed_at"], name: "index_identities_on_confirmed_at"
    t.index ["email", "encrypted_password"], name: "index_identities_on_email_and_encrypted_password"
    t.index ["email"], name: "index_identities_on_email"
    t.index ["encrypted_password"], name: "index_identities_on_encrypted_password"
    t.index ["recovery_sent_at"], name: "index_identities_on_recovery_sent_at"
    t.index ["recovery_token"], name: "index_identities_on_recovery_token"
  end

  create_table "tickets", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "identity_id"
    t.string "title"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_tickets_on_identity_id"
    t.index ["status"], name: "index_tickets_on_status"
  end

end
