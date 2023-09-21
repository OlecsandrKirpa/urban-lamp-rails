# frozen_string_literal: true

class CreatePlaylistFollowers < ActiveRecord::Migration[7.0]
  def change
    create_table :playlist_followers do |t|
      t.belongs_to :playlist, null: false, foreign_key: false, index: true
      t.belongs_to :user,     null: false, foreign_key: false, index: true

      t.timestamps
    end
  end
end
