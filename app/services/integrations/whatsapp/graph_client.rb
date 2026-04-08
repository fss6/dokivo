# frozen_string_literal: true

require "net/http"
require "json"
require "uri"

module Integrations
  module Whatsapp
    class GraphClient
      DEFAULT_API_VERSION = "v22.0"
      GRAPH_HOST = "graph.facebook.com"

      def initialize(integration_connection)
        @connection = integration_connection
        @version = ENV.fetch("WHATSAPP_API_VERSION", DEFAULT_API_VERSION)
      end

      # GET no recurso do número — útil para validar token e phone_number_id.
      def fetch_phone_number(fields: "id,display_phone_number,verified_name")
        uri = URI::HTTPS.build(
          host: GRAPH_HOST,
          path: "/#{@version}/#{@connection.phone_number_id}",
          query: URI.encode_www_form("fields" => fields)
        )

        req = Net::HTTP::Get.new(uri)
        req["Authorization"] = "Bearer #{@connection.access_token}"

        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          http.request(req)
        end
      end

      # +to+ — ID WhatsApp (normalmente apenas dígitos, sem +).
      def send_text(to:, body:)
        uri = URI::HTTPS.build(
          host: GRAPH_HOST,
          path: "/#{@version}/#{@connection.phone_number_id}/messages"
        )

        payload = {
          messaging_product: "whatsapp",
          to: to.to_s,
          type: "text",
          text: { body: body.to_s.truncate(4096) }
        }

        req = Net::HTTP::Post.new(uri)
        req["Authorization"] = "Bearer #{@connection.access_token}"
        req["Content-Type"] = "application/json; charset=utf-8"
        req.body = JSON.generate(payload)

        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          res = http.request(req)
          unless res.is_a?(Net::HTTPSuccess)
            Rails.logger.error(
              "[WhatsApp Graph] send_text failed status=#{res.code} body=#{res.body.to_s.truncate(500)}"
            )
          end
          res
        end
      end
    end
  end
end
