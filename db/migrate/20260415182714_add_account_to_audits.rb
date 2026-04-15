class AddAccountToAudits < ActiveRecord::Migration[8.0]
  def change
    add_reference :audits, :account, null: true, foreign_key: true
    add_index :audits, [:account_id, :created_at], name: "index_audits_on_account_id_and_created_at"
  end
end
