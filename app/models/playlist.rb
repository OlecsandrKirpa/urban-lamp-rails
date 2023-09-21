# frozen_string_literal: true

class Playlist < ApplicationRecord
  validates :visibility, presence: true, inclusion: { in: %w[public private] }

  belongs_to :user, required: true
  has_many :videos, dependent: :destroy

  scope :public_visibility, -> { where(visibility: 'public') }
  scope :private_visibility, -> { where(visibility: 'private') }

  before_validation :assign_defaults

  def public?
    visibility == 'public'
  end

  def private?
    visibility == 'private'
  end

  def public!
    update(visibility: 'public')
  end

  def private!
    update(visibility: 'private')
  end

  def assign_defaults
    self.visibility ||= 'private'
  end
end
