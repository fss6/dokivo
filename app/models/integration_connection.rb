# frozen_string_literal: true

# Credenciais por conta para canais externos (WhatsApp Cloud API primeiro; outras integrações podem
# reutilizar este modelo com outros valores de +provider+).
class IntegrationConnection < ApplicationRecord
  PROVIDERS = %w[whatsapp_cloud].freeze

  belongs_to :account

  has_many :conversations, dependent: :nullify
  has_many :integration_inbound_events, dependent: :delete_all

  validates :provider, presence: true, inclusion: { in: PROVIDERS }
  validates :phone_number_id, presence: true
  validates :verify_token, presence: true
  validates :access_token, presence: true
  validates :phone_number_id, uniqueness: { scope: :account_id }
  validates :verify_token, uniqueness: true

  validate :whatsapp_cloud_tokens_not_swapped

  scope :active, -> { where(active: true) }

  before_validation :normalize_verify_token
  before_validation :normalize_access_token

  def self.find_active_by_verify_token(token)
    t = token.to_s.strip
    return if t.blank?

    active.find_by(verify_token: t) ||
      active.where("BTRIM(verify_token) = ?", t).first
  end

  def self.find_active_by_phone_number_id(pid)
    active.find_by(phone_number_id: pid.to_s)
  end

  def whatsapp_cloud?
    provider == "whatsapp_cloud"
  end

  # Para alinhar com o campo "Verify token" na Meta (comparação sem mostrar o token completo na UI).
  def verify_token_hint
    t = verify_token.to_s
    return "—" if t.blank?

    "…#{t.last(4)} (#{t.length} caracteres)"
  end

  private

  def normalize_verify_token
    self.verify_token = verify_token.to_s.strip if verify_token.present?
  end

  def normalize_access_token
    self.access_token = access_token.to_s.strip if access_token.present?
  end

  # Tokens da Graph costumam começar por EA… e ter dezenas de caracteres; o verify token do webhook é uma
  # palavra-chave curta definida por ti na Meta — confundir os campos é o erro mais comum.
  def whatsapp_cloud_tokens_not_swapped
    return unless whatsapp_cloud?

    vt = verify_token.to_s.strip
    at = access_token.to_s.strip
    return if vt.blank? || at.blank?

    verify_looks_like_graph = vt.match?(/\AEA[A-Za-z0-9]{50,}\z/)
    access_looks_like_graph = at.match?(/\AEA[A-Za-z0-9]{50,}\z/)

    return unless verify_looks_like_graph && !access_looks_like_graph && at.length < 120

    errors.add(
      :verify_token,
      "parece um access token da Meta (longo, começado por EA…). Esse valor deve ir no campo «Access token». " \
      "Aqui use só o verify token: a palavra-chave curta igual à de Meta → Webhooks → Verify token."
    )
    errors.add(
      :access_token,
      "parece o verify token do webhook (curto). Esse valor deve ir no campo «Verify token». " \
      "Aqui cole o token permanente / de sistema (texto longo) gerado na Meta."
    )
  end
end
