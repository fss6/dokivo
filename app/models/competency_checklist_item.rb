class CompetencyChecklistItem < ApplicationRecord
  belongs_to :competency_checklist, inverse_of: :items
  belongs_to :client_checklist_item, optional: true
  belongs_to :last_document, class_name: "Document", optional: true
  belongs_to :validated_by_user, class_name: "User", optional: true, inverse_of: :validated_competency_checklist_items

  enum :state, {
    pending: "pending",
    received: "received",
    validated: "validated"
  }, default: :pending

  validates :name_snapshot, presence: true
  validate :last_document_must_match_checklist_competency

  def match_terms
    value = read_attribute(:match_terms)
    value.is_a?(Array) ? value : []
  end

  def mark_validated!(user:)
    update!(
      state: :validated,
      validated_by_user: user,
      validated_at: Time.current
    )
  end

  def mark_pending!
    update!(
      state: :pending,
      validated_by_user: nil,
      validated_at: nil
    )
  end

  private

  def last_document_must_match_checklist_competency
    return if last_document.blank? || competency_checklist.blank?

    folder = last_document.folder
    expected_folder_name = competency_checklist.period.strftime("%Y-%m")

    valid_folder = folder.present? &&
      folder.account_id == competency_checklist.account_id &&
      folder.client_id == competency_checklist.client_id &&
      folder.name == expected_folder_name

    return if valid_folder

    errors.add(:last_document, "deve pertencer a pasta da mesma competencia do checklist")
  end
end
