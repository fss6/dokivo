# frozen_string_literal: true

require "json"
require "net/http"

module Integrations
  module Whatsapp
    # Valida credenciais com um GET na Graph API (não envia mensagem ao utilizador final).
    class ConnectionTester
      Result = Struct.new(:success, :message, keyword_init: true) do
        def success?
          success
        end
      end

      def self.call(integration_connection)
        new(integration_connection).call
      end

      def initialize(integration_connection)
        @connection = integration_connection
      end

      def call
        unless @connection.active?
          return Result.new(success: false, message: "A integração está inativa. Ative-a antes de testar.")
        end

        res = GraphClient.new(@connection).fetch_phone_number
        body = res.body.to_s
        parsed =
          begin
            body.present? ? JSON.parse(body) : {}
          rescue JSON::ParserError
            return Result.new(success: false, message: "Resposta inválida da Meta (HTTP #{res.code}).")
          end
        parsed = {} unless parsed.is_a?(Hash)

        if res.is_a?(Net::HTTPSuccess) && parsed["error"].blank?
          display = parsed["display_phone_number"].presence || @connection.display_phone_number
          msg = "Conexão OK com a Meta."
          msg += " Número: #{display}." if display.present?
          Result.new(success: true, message: msg)
        else
          err = parsed["error"]
          detail =
            if err.is_a?(Hash)
              [err["code"], err["message"]].compact.join(" — ")
            else
              body.truncate(300)
            end
          Result.new(
            success: false,
            message: "A Meta recusou o pedido (HTTP #{res.code}). #{detail.presence || 'Verifique o access token e o phone number ID.'}"
          )
        end
      rescue StandardError => e
        Rails.logger.error("[WhatsApp ConnectionTester] #{e.class}: #{e.message}")
        Result.new(success: false, message: "Erro ao contactar a Meta: #{e.message}")
      end
    end
  end
end
