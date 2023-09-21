class CreatePlaylists < ActiveRecord::Migration[7.0]
  def change
    create_table :playlists do |t|
      t.text :visibility, null: false
      t.text :name,       null: true
      t.text :notes,      null: true
      t.belongs_to :user, null: false, foreign_key: false, index: true

      t.timestamps
    end
  end
end
