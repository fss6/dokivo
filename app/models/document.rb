class Document < ApplicationRecord
  belongs_to :account
  belongs_to :user
  belongs_to :folder

  has_one_attached :file

  has_many :embedding_records, as: :recordable, dependent: :destroy

  enum :status, {
    pending: "pending",
    processing: "processing",
    processed: "processed",
    failed: "failed"
  }, default: :pending

  validate :user_belongs_to_account
  validate :folder_belongs_to_account
  # validates :file, attached: true, on: :create

  private

  def user_belongs_to_account
    return if account_id.blank? || user_id.blank?
    return if user&.account_id == account_id

    errors.add(:user_id, "deve pertencer à mesma conta selecionada")
  end

  def folder_belongs_to_account
    return if account_id.blank? || folder_id.blank?
    return if folder&.account_id == account_id

    errors.add(:folder_id, "deve pertencer à mesma conta selecionada")
  end
end
