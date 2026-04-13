# frozen_string_literal: true

class CreateBankStatementImports < ActiveRecord::Migration[8.0]
  def change
    create_table :bank_statement_imports do |t|
      t.references :account, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.string :status, default: "pending", null: false
      t.jsonb :metadata, default: {}, null: false
      t.text :ocr_text

      t.timestamps
    end

    add_index :bank_statement_imports, :status
    add_index :bank_statement_imports, [:client_id, :created_at]
  end
end

