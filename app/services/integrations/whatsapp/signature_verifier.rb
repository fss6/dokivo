# frozen_string_literal: true

module Integrations
  module Whatsapp
    # Valida X-Hub-Signature-256 (Meta). Use o body bruto exatamente como recebido.
    module SignatureVerifier
      module_function

      def valid?(raw_body:, signature_header:, app_secret: nil)
        secret = app_secret.presence || ENV.fetch("WHATSAPP_APP_SECRET", "")
        return false if secret.blank? || signature_header.blank? || raw_body.nil?

        expected = "sha256=#{OpenSSL::HMAC.hexdigest('SHA256', secret, raw_body)}"
        ActiveSupport::SecurityUtils.secure_compare(signature_header, expected)
      end
    end
  end
end
