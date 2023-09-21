# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: { case_sensitive: false, allow_nil: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, uniqueness: { allow_nil: true, case_sensitive: false }, format: { with: /\A[a-zA-Z0-9\.\-_]+\z/ }, allow_nil: true
  validates :password_digest, presence: true

  has_many :playlists, dependent: :destroy
  has_many :videos, through: :playlists, dependent: :destroy
end
