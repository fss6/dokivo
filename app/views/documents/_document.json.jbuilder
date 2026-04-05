json.extract! document, :id, :account_id, :user_id, :folder_id, :content, :summary, :status, :metadata, :created_at, :updated_at
json.url document_url(document, format: :json)
json.embedding_records document.embedding_records.ordered_for_display do |record|
  json.extract! record, :id, :content, :created_at, :updated_at
  json.page record.page_number
  json.chunk_index record.chunk_index
  json.metadata record.metadata
end
