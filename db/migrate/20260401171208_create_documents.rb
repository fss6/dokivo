class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.references :account, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :folder, null: false, foreign_key: true
      t.text :content
      t.text :summary
      t.string :status
      t.jsonb :metadata

      t.timestamps
    end
  end
end
