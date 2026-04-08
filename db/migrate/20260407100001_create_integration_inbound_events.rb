# frozen_string_literal: true

class CreateIntegrationInboundEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :integration_inbound_events do |t|
      t.references :integration_connection, null: false, foreign_key: true
      t.string :provider_event_id, null: false

      t.timestamps
    end

    add_index :integration_inbound_events, :provider_event_id, unique: true,
              name: "index_integration_inbound_events_on_provider_event_id"
  end
end
