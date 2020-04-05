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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161010083506) do

  create_table "appointments", force: :cascade do |t|
    t.integer  "chief_id",    limit: 4,   default: 0
    t.integer  "user_id_set", limit: 4,   default: 0
    t.integer  "user_id",     limit: 4,   default: 0
    t.integer  "article_id",  limit: 4,   default: 0
    t.datetime "date_plan"
    t.datetime "date_fact"
    t.string   "comment",     limit: 255
    t.integer  "score",       limit: 4,   default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "articles", force: :cascade do |t|
    t.text     "title",          limit: 65535
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "publication_id", limit: 4,     default: 0, null: false
    t.integer  "user_id",        limit: 4,     default: 0
    t.integer  "proofreader_id", limit: 4,     default: 0
    t.string   "udk",            limit: 255
    t.text     "annotation",     limit: 65535
    t.text     "annotation_en",  limit: 65535
    t.string   "keywords",       limit: 255
    t.string   "keywords_en",    limit: 255
    t.string   "title_en",       limit: 255
  end

  add_index "articles", ["publication_id"], name: "fk_article_publication_id_idx", using: :btree

  create_table "authors", force: :cascade do |t|
    t.string   "surname",     limit: 255
    t.string   "mainname",    limit: 255
    t.string   "middlename",  limit: 255
    t.string   "shortname",   limit: 255
    t.string   "shortnameen", limit: 255
    t.string   "email",       limit: 255
    t.string   "moretext",    limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "user_id",     limit: 4
  end

  create_table "comment_types", force: :cascade do |t|
    t.string   "comment_type", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string   "commenter",         limit: 255
    t.text     "body",              limit: 65535
    t.integer  "article_id",        limit: 4
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size",    limit: 4
    t.datetime "file_updated_at"
    t.integer  "comment_type_id",   limit: 4,     default: 0
    t.integer  "user_id",           limit: 4
  end

  add_index "comments", ["article_id"], name: "index_comments_on_article_id", using: :btree
  add_index "comments", ["comment_type_id"], name: "index_comments_on_comment_type_id", using: :btree

  create_table "degrees", force: :cascade do |t|
    t.integer  "author_id",      limit: 4
    t.integer  "institution_id", limit: 4
    t.string   "info",           limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "position",       limit: 4
    t.integer  "user_id",        limit: 4
  end

  add_index "degrees", ["author_id"], name: "index_degrees_on_author_id", using: :btree
  add_index "degrees", ["institution_id"], name: "index_degrees_on_institution_id", using: :btree

  create_table "hhgrab", force: :cascade do |t|
    t.string "url",     limit: 200
    t.date   "date"
    t.string "who_add", limit: 45
  end

  create_table "institutions", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.string   "postaddress",     limit: 255
    t.string   "webaddress",      limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "titleingenitive", limit: 255
    t.boolean  "checkedbyadmin"
    t.integer  "user_id",         limit: 4
  end

  create_table "journals", force: :cascade do |t|
    t.string   "title",               limit: 255
    t.text     "descr",               limit: 65535
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "user_id",             limit: 4
    t.string   "udk",                 limit: 255
    t.string   "website",             limit: 255
    t.text     "editorial_board",     limit: 65535
    t.string   "arules_file_name",    limit: 255
    t.string   "arules_content_type", limit: 255
    t.integer  "arules_file_size",    limit: 4
    t.datetime "arules_updated_at"
    t.string   "logo_file_name",      limit: 255
    t.string   "logo_content_type",   limit: 255
    t.integer  "logo_file_size",      limit: 4
    t.datetime "logo_updated_at"
    t.string   "ISSN",                limit: 255,   default: ""
  end

  create_table "mailboxer_conversation_opt_outs", force: :cascade do |t|
    t.integer "unsubscriber_id",   limit: 4
    t.string  "unsubscriber_type", limit: 255
    t.integer "conversation_id",   limit: 4
  end

  add_index "mailboxer_conversation_opt_outs", ["conversation_id"], name: "mb_opt_outs_on_conversations_id", using: :btree

  create_table "mailboxer_conversations", force: :cascade do |t|
    t.string   "subject",    limit: 255, default: ""
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "mailboxer_notifications", force: :cascade do |t|
    t.string   "type",                 limit: 255
    t.text     "body",                 limit: 65535
    t.string   "subject",              limit: 255,   default: ""
    t.integer  "sender_id",            limit: 4
    t.string   "sender_type",          limit: 255
    t.integer  "conversation_id",      limit: 4
    t.boolean  "draft",                              default: false
    t.string   "notification_code",    limit: 255
    t.integer  "notified_object_id",   limit: 4
    t.string   "notified_object_type", limit: 255
    t.string   "attachment",           limit: 255
    t.datetime "updated_at",                                         null: false
    t.datetime "created_at",                                         null: false
    t.boolean  "global",                             default: false
    t.datetime "expires"
  end

  add_index "mailboxer_notifications", ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id", using: :btree

  create_table "mailboxer_receipts", force: :cascade do |t|
    t.integer  "receiver_id",     limit: 4
    t.string   "receiver_type",   limit: 255
    t.integer  "notification_id", limit: 4,                   null: false
    t.boolean  "is_read",                     default: false
    t.boolean  "trashed",                     default: false
    t.boolean  "deleted",                     default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "mailboxer_receipts", ["notification_id"], name: "index_mailboxer_receipts_on_notification_id", using: :btree

  create_table "materials", force: :cascade do |t|
    t.string   "file_file_name",                limit: 255
    t.string   "file_content_type",             limit: 255
    t.integer  "file_file_size",                limit: 4
    t.datetime "file_updated_at"
    t.integer  "checked_by_chief_id",           limit: 4,     default: 0
    t.integer  "checked_by_chief_assistant_id", limit: 4,     default: 0
    t.integer  "checked_by_proofreader_id",     limit: 4,     default: 0
    t.integer  "checked_by_author_id",          limit: 4,     default: 0
    t.integer  "position",                      limit: 4
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.string   "file_pdf_file_name",            limit: 255
    t.string   "file_pdf_content_type",         limit: 255
    t.integer  "file_pdf_file_size",            limit: 4
    t.datetime "file_pdf_updated_at"
    t.integer  "article_id",                    limit: 4
    t.text     "comment",                       limit: 65535
    t.integer  "is_bibliography_ready",         limit: 4,     default: 0
    t.integer  "is_images_ready",               limit: 4,     default: 0
    t.integer  "is_formulas_ready",             limit: 4,     default: 0
    t.integer  "pages_count",                   limit: 4,     default: 0
  end

  create_table "paternities", force: :cascade do |t|
    t.integer  "article_id", limit: 4
    t.integer  "author_id",  limit: 4
    t.integer  "position",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "user_id",    limit: 4
  end

  create_table "portion_types", force: :cascade do |t|
    t.string   "portion_type",    limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "add_to_contents", limit: 4
    t.integer  "is_numbering",    limit: 4
  end

  create_table "portions", force: :cascade do |t|
    t.integer  "ftype",                 limit: 4
    t.integer  "position",              limit: 4
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "file_file_name",        limit: 255
    t.string   "file_content_type",     limit: 255
    t.integer  "file_file_size",        limit: 4
    t.datetime "file_updated_at"
    t.integer  "publication_id",        limit: 4
    t.integer  "pages_count",           limit: 4,   default: 0
    t.string   "file_pdf_file_name",    limit: 255
    t.string   "file_pdf_content_type", limit: 255
    t.integer  "file_pdf_file_size",    limit: 4
    t.datetime "file_pdf_updated_at"
    t.integer  "add_to_contents",       limit: 4,   default: 0
    t.string   "name_in_contents",      limit: 255, default: ""
    t.integer  "is_numbering",          limit: 4,   default: 0
  end

  create_table "publication_statuses", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.integer  "order_id",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "publications", force: :cascade do |t|
    t.integer  "pubno",                      limit: 4
    t.string   "pubtxt",                     limit: 255
    t.integer  "journal_id",                 limit: 4
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "publication_status_id",      limit: 4,     default: 0,  null: false
    t.date     "publish_plan"
    t.text     "introduction",               limit: 65535
    t.integer  "pages_multiplicity",         limit: 4,     default: 4
    t.string   "website_cover_file_name",    limit: 255
    t.string   "website_cover_content_type", limit: 255
    t.integer  "website_cover_file_size",    limit: 4
    t.datetime "website_cover_updated_at"
    t.string   "ISBN",                       limit: 255,   default: ""
    t.string   "file_file_name",             limit: 255
    t.string   "file_content_type",          limit: 255
    t.integer  "file_file_size",             limit: 4
    t.datetime "file_updated_at"
  end

  add_index "publications", ["journal_id"], name: "index_publications_on_journal_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",        limit: 255,   null: false
    t.string   "title",       limit: 255,   null: false
    t.text     "description", limit: 65535, null: false
    t.text     "the_role",    limit: 65535, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uroles", force: :cascade do |t|
    t.integer  "chief_id",       limit: 4
    t.string   "email",          limit: 255
    t.integer  "user_id",        limit: 4
    t.integer  "publication_id", limit: 4
    t.integer  "role_id",        limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "role_id",                limit: 4
    t.integer  "author_id",              limit: 4,   default: 0
    t.string   "username",               limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "comments", "articles"
  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", column: "conversation_id", name: "mb_opt_outs_on_conversations_id"
  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", column: "conversation_id", name: "notifications_on_conversation_id"
  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", column: "notification_id", name: "receipts_on_notification_id"
  add_foreign_key "publications", "journals"
end
