# frozen_string_literal: true

module Integrations
  module Whatsapp
    class DeliverReplyJob < ApplicationJob
      queue_as :default

      def perform(message_id)
        message = Message.find_by(id: message_id)
        return if message.blank? || !message.assistant?

        conversation = message.conversation
        return unless conversation.whatsapp?

        connection = conversation.integration_connection
        return if connection.blank?

        meta = message.metadata.is_a?(Hash) ? message.metadata.stringify_keys : {}
        return if meta["whatsapp_sent"].present?

        to = conversation.external_sender_id
        return if to.blank?

        body = message.content.to_s
        return if body.blank?

        Integrations::Whatsapp::GraphClient.new(connection).send_text(to: to, body: body)

        message.update!(
          metadata: meta.merge("whatsapp_sent" => true, "whatsapp_sent_at" => Time.current.iso8601)
        )
      end
    end
  end
end
