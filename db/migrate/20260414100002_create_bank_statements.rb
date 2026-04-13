# frozen_string_literal: true

class CreateBankStatements < ActiveRecord::Migration[8.0]
  def change
    create_table :bank_statements do |t|
      t.references :account, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.references :bank_statement_import, null: false, foreign_key: true
      t.date :occurred_on, null: false
      t.decimal :amount, precision: 16, scale: 2, null: false
      t.string :transaction_type, null: false
      t.references :institution, null: false, foreign_key: true
      t.text :description, null: false

      t.timestamps
    end

    add_index :bank_statements, [:client_id, :occurred_on]
  end
end

