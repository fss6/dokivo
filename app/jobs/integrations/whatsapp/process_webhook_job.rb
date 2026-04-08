# frozen_string_literal: true

module Integrations
  module Whatsapp
    class ProcessWebhookJob < ApplicationJob
      queue_as :default

      def perform(payload_json)
        data = JSON.parse(payload_json).with_indifferent_access
        return unless data[:object].to_s == "whatsapp_business_account"

        Array(data[:entry]).each do |entry|
          Array(entry[:changes]).each do |change|
            value = change[:value]
            next if value.blank?

            metadata = value[:metadata]
            next if metadata.blank?

            phone_number_id = metadata[:phone_number_id].to_s
            connection = IntegrationConnection.find_active_by_phone_number_id(phone_number_id)
            if connection.blank?
              Rails.logger.warn("[WhatsApp] No IntegrationConnection for phone_number_id=#{phone_number_id}")
              next
            end

            process_messages(connection, value)
          end
        end
      end

      private

      def process_messages(connection, value)
        ActsAsTenant.with_tenant(connection.account) do
          Array(value[:messages]).each do |msg|
            next if msg[:type].to_s != "text"

            wamid = msg[:id].to_s
            next if wamid.blank?

            from = msg[:from].to_s
            text = msg.dig(:text, :body).to_s.strip
            next if text.blank?

            begin
              ai_message_id = nil
              conversation_id = nil
              user_message_id = nil
              enqueue_title_job = false

              ActiveRecord::Base.transaction do
                IntegrationInboundEvent.create!(
                  integration_connection: connection,
                  provider_event_id: wamid
                )

                conversation = Conversation.find_or_create_for_whatsapp!(
                  account: connection.account,
                  connection: connection,
                  external_sender_id: from
                )

                user_message = conversation.messages.create!(
                  role: "user",
                  content: text,
                  streaming: false,
                  metadata: { "whatsapp_wamid" => wamid }
                )

                ai_message = conversation.messages.create!(role: "assistant", content: "", streaming: true)
                ai_message_id = ai_message.id
                conversation_id = conversation.id
                user_message_id = user_message.id
                enqueue_title_job = conversation.default_title?
              end

              RagQueryJob.perform_later(ai_message_id) if ai_message_id
              if enqueue_title_job
                ConversationTitleJob.perform_later(conversation_id, user_message_id)
              end
            rescue ActiveRecord::RecordNotUnique
              # Webhook duplicado: mesmo wamid.
              next
            end
          end
        end
      end
    end
  end
end
