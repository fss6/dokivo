# frozen_string_literal: true

class CreateClients < ActiveRecord::Migration[8.0]
  def change
    create_table :clients do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name, null: false
      t.string :tax_id
      t.string :email
      t.string :phone
      t.text :notes

      t.timestamps
    end

    add_index :clients, [:account_id, :tax_id], unique: true, where: "tax_id IS NOT NULL AND tax_id <> ''"
  end
end
