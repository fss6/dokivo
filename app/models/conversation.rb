# frozen_string_literal: true

class Conversation < ApplicationRecord
  CHANNELS = %w[web whatsapp].freeze

  acts_as_tenant(:account)
  DEFAULT_TITLE = "Nova conversa"
  TITLE_MAX_LENGTH = 255

  belongs_to :user
  belongs_to :integration_connection, optional: true

  has_many :messages, dependent: :destroy

  validates :title, length: { maximum: TITLE_MAX_LENGTH }, allow_blank: true
  validates :channel, inclusion: { in: CHANNELS }
  validate :whatsapp_channel_consistency
  validate :web_channel_consistency

  def default_title?
    title.blank? || title == DEFAULT_TITLE
  end

  def whatsapp?
    channel == "whatsapp"
  end

  def self.find_or_create_for_whatsapp!(account:, connection:, external_sender_id:)
    raise ArgumentError, "external_sender_id required" if external_sender_id.blank?

    owner = account.users.role_owner.order(:id).first || account.users.order(:id).first
    raise ActiveRecord::RecordNotFound, "Account #{account.id} has no users" if owner.blank?

    ActsAsTenant.with_tenant(account) do
      Conversation.create_or_find_by!(
        integration_connection_id: connection.id,
        external_sender_id: external_sender_id,
        channel: "whatsapp"
      ) do |c|
        c.user = owner
        c.title = DEFAULT_TITLE
      end
    end
  end

  private

  def whatsapp_channel_consistency
    return unless channel == "whatsapp"

    errors.add(:integration_connection_id, "é obrigatório para WhatsApp") if integration_connection_id.blank?
    errors.add(:external_sender_id, "é obrigatório para WhatsApp") if external_sender_id.blank?
  end

  def web_channel_consistency
    return unless channel == "web"

    errors.add(:integration_connection_id, "deve ficar em branco para conversas web") if integration_connection_id.present?
    errors.add(:external_sender_id, "deve ficar em branco para conversas web") if external_sender_id.present?
  end
end
