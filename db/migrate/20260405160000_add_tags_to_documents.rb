# frozen_string_literal: true

class AddTagsToDocuments < ActiveRecord::Migration[8.0]
  def change
    add_column :documents, :tags, :jsonb, null: false, default: []
    add_index :documents, :tags, using: :gin
  end
end
