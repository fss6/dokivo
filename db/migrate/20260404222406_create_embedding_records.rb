class CreateEmbeddingRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :embedding_records do |t|
      t.references :account, null: false, foreign_key: true
      t.integer :document_id, null: true
      t.text :content
      t.vector :embedding, limit: 1536
      t.references :recordable, polymorphic: true, index: true
      t.jsonb :metadata

      t.timestamps
    end

    add_index :embedding_records, :embedding, using: :ivfflat, opclass: :vector_cosine_ops
    add_index :embedding_records, [:account_id, :document_id]
  end
end
