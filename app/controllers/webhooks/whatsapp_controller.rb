# frozen_string_literal: true

module Webhooks
  class WhatsappController < ActionController::API
    def verify
      # A Meta envia hub.mode / hub.challenge / hub.verify_token; alguns proxies duplicam como hub_*.
      mode = meta_param("hub.mode", "hub_mode")
      token = meta_param("hub.verify_token", "hub_verify_token")
      challenge = meta_param("hub.challenge", "hub_challenge")

      unless mode.to_s == "subscribe"
        Rails.logger.warn("[WhatsApp] verify rejected: hub.mode is #{mode.inspect}, expected subscribe")
        head :forbidden
        return
      end

      if token.blank?
        Rails.logger.warn("[WhatsApp] verify rejected: missing verify_token")
        head :forbidden
        return
      end

      if challenge.blank?
        Rails.logger.warn("[WhatsApp] verify rejected: missing hub.challenge")
        head :forbidden
        return
      end

      connection = IntegrationConnection.find_active_by_verify_token(token)
      if connection.blank?
        has_inactive = IntegrationConnection.where(verify_token: token.to_s.strip).where(active: false).exists?
        t = token.to_s.strip
        suffix = t.length >= 4 ? t.last(4) : "?"
        Rails.logger.warn(
          "[WhatsApp] verify rejected: nenhuma IntegrationConnection ativa com este verify_token " \
          "(inactive_match=#{has_inactive}, len=#{t.bytesize}, sufixo_recebido=…#{suffix}). " \
          "Em Dokivo → Integrações, o campo Verify token tem de coincidir byte a byte com o da Meta."
        )
        head :forbidden
        return
      end

      Rails.logger.info("[WhatsApp] Webhook verified for integration_connection_id=#{connection.id}")
      render plain: challenge.to_s, status: :ok
    end

    def receive
      raw_body = request.raw_post
      signature = request.headers["X-Hub-Signature-256"]

      signature_ok =
        if Rails.env.development? && ENV["SKIP_WHATSAPP_SIGNATURE"].to_s == "1"
          Rails.logger.warn("[WhatsApp] Skipping webhook signature check (SKIP_WHATSAPP_SIGNATURE=1)")
          true
        else
          Integrations::Whatsapp::SignatureVerifier.valid?(
            raw_body: raw_body,
            signature_header: signature.to_s
          )
        end

      unless signature_ok
        Rails.logger.warn("[WhatsApp] Invalid webhook signature")
        head :unauthorized
        return
      end

      Integrations::Whatsapp::ProcessWebhookJob.perform_later(raw_body)
      head :ok
    end

    private

    def meta_param(dotted, underscored)
      params[dotted].presence || params[underscored.to_sym].presence || params[underscored.to_s].presence
    end
  end
end
