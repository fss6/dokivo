json.extract! document, :id, :account_id, :user_id, :folder_id, :content, :summary, :status, :metadata, :created_at, :updated_at
json.url document_url(document, format: :json)
