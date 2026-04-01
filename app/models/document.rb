class Document < ApplicationRecord
  belongs_to :account
  belongs_to :user
  belongs_to :folder

  has_one_attached :file

  enum :status, {
    pending: 'pending',
    processing: 'processing',
    processed: 'processed',
    failed: 'failed'
  }, prefix: true, default: :pending
end
