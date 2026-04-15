class CreateAuditEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :audit_events do |t|
      t.references :account, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.string :event_type, null: false
      t.references :subject, polymorphic: true, null: false
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :audit_events, [:account_id, :event_type, :created_at], name: "index_audit_events_on_account_event_and_created_at"
    add_index :audit_events, [:user_id, :created_at], name: "index_audit_events_on_user_id_and_created_at"
  end
end
