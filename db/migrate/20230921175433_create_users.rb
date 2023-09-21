# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.text :email, null: false, index: { unique: true }
      t.text :password_digest, null: false
      t.text :username, null: true, index: { unique: true, where: 'username IS NOT NULL' }

      t.timestamps
    end
  end
end
