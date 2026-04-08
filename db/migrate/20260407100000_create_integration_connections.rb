# frozen_string_literal: true

class CreateIntegrationConnections < ActiveRecord::Migration[8.0]
  def change
    create_table :integration_connections do |t|
      t.references :account, null: false, foreign_key: true
      t.string :provider, null: false, default: "whatsapp_cloud"
      t.string :phone_number_id, null: false
      t.string :display_phone_number
      t.string :verify_token, null: false
      t.text :access_token, null: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :integration_connections, %i[account_id phone_number_id], unique: true,
              name: "index_integration_connections_on_account_and_phone_number_id"
    add_index :integration_connections, :phone_number_id, unique: true,
              name: "index_integration_connections_on_phone_number_id_unique"
    add_index :integration_connections, :verify_token, unique: true
  end
end
