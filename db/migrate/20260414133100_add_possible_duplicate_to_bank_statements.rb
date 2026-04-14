# frozen_string_literal: true

class AddPossibleDuplicateToBankStatements < ActiveRecord::Migration[8.0]
  def change
    add_column :bank_statements, :possible_duplicate, :boolean, null: false, default: false
  end
end
