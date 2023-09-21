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

ActiveRecord::Schema[7.0].define(version: 2023_09_21_182107) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "playlist_followers", force: :cascade do |t|
    t.bigint "playlist_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["playlist_id"], name: "index_playlist_followers_on_playlist_id"
    t.index ["user_id"], name: "index_playlist_followers_on_user_id"
  end

  create_table "playlists", force: :cascade do |t|
    t.text "visibility", null: false
    t.text "name"
    t.text "notes"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_playlists_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "email", null: false
    t.text "password_digest", null: false
    t.text "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true, where: "(username IS NOT NULL)"
  end

  create_table "videos", force: :cascade do |t|
    t.text "url", comment: "The URL of the video."
    t.text "download_jid", comment: "The job ID of the download job."
    t.text "downloader", comment: "The class that will perform the download."
    t.jsonb "downloader_args", comment: "The arguments that will be passed to the downloader."
    t.boolean "valid_media", default: false, null: false, comment: "Whether the video is valid. This is set to true after the video has been downloaded and validated."
    t.integer "download_attempts", default: 0, null: false, comment: "The number of times the video has been attempted to be downloaded."
    t.jsonb "download_error", comment: "The error that occurred when attempting to download the video."
    t.bigint "playlist_id", null: false, comment: "The playlist that the video belongs to."
    t.bigint "user_id", null: false, comment: "The user that the video belongs to."
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["download_jid"], name: "index_videos_on_download_jid", unique: true, where: "(download_jid IS NOT NULL)"
    t.index ["playlist_id", "url"], name: "index_videos_on_playlist_id_and_url", unique: true, where: "(url IS NOT NULL)"
    t.index ["playlist_id"], name: "index_videos_on_playlist_id"
    t.index ["user_id"], name: "index_videos_on_user_id"
  end

end
