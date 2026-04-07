# frozen_string_literal: true

class Conversation < ApplicationRecord
  acts_as_tenant(:account)
  DEFAULT_TITLE = "Nova conversa"
  TITLE_MAX_LENGTH = 255

  belongs_to :user

  has_many :messages, dependent: :destroy

  validates :title, length: { maximum: TITLE_MAX_LENGTH }, allow_blank: true

  def default_title?
    title.blank? || title == DEFAULT_TITLE
  end
end
