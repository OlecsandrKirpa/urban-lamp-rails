# frozen_string_literal: true

class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.text    :url,                 null: true, comment: %(The URL of the video.)
      t.text    :download_jid,        null: true, index: { unique: true, where: 'download_jid IS NOT NULL' }, comment: %(The job ID of the download job.)
      t.text    :downloader,          comment: %(The class that will perform the download.)
      t.jsonb   :downloader_args,     comment: %(The arguments that will be passed to the downloader.)
      t.boolean :valid_media,         null: false, default: false, comment: %(Whether the video is valid. This is set to true after the video has been downloaded and validated.)
      t.integer :download_attempts,   null: false, default: 0, comment: %(The number of times the video has been attempted to be downloaded.)
      t.jsonb   :download_error,     null: true, comment: %(The error that occurred when attempting to download the video.)

      t.belongs_to :playlist,         null: false, foreign_key: false, index: true, comment: %(The playlist that the video belongs to.)
      t.belongs_to :user,             null: false, foreign_key: false, index: true, comment: %(The user that the video belongs to.)

      t.timestamps

      t.index %i[playlist_id url], unique: true, where: 'url IS NOT NULL'
    end
  end
end
