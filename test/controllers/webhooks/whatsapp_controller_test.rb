# frozen_string_literal: true

require "test_helper"

class Webhooks::WhatsappControllerTest < ActionDispatch::IntegrationTest
  test "verify returns hub challenge when verify_token matches active connection" do
    conn = integration_connections(:one)
    get webhooks_whatsapp_url, params: {
      "hub.mode" => "subscribe",
      "hub.verify_token" => conn.verify_token,
      "hub.challenge" => "CHALLENGE_ACCEPTED"
    }
    assert_response :ok
    assert_equal "CHALLENGE_ACCEPTED", response.body
  end

  test "verify is forbidden when verify_token does not match" do
    get webhooks_whatsapp_url, params: {
      "hub.mode" => "subscribe",
      "hub.verify_token" => "wrong-token",
      "hub.challenge" => "x"
    }
    assert_response :forbidden
  end

  test "receive enqueues ProcessWebhookJob when signature check skipped" do
    ENV["SKIP_WHATSAPP_SIGNATURE"] = "1"
    assert_enqueued_with(job: Integrations::Whatsapp::ProcessWebhookJob) do
      post webhooks_whatsapp_url,
           params: { object: "whatsapp_business_account", entry: [] },
           as: :json
    end
  ensure
    ENV.delete("SKIP_WHATSAPP_SIGNATURE")
  end
end
