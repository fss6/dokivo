# frozen_string_literal: true

class AddChannelFieldsToConversations < ActiveRecord::Migration[8.0]
  def change
    add_reference :conversations, :integration_connection, foreign_key: true, null: true
    add_column :conversations, :channel, :string, null: false, default: "web"
    add_column :conversations, :external_sender_id, :string

    add_index :conversations,
              %i[integration_connection_id external_sender_id channel],
              unique: true,
              name: "index_conversations_on_whatsapp_thread",
              where: "channel = 'whatsapp' AND external_sender_id IS NOT NULL"
  end
end
