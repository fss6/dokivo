class CompetencyChecklist < ApplicationRecord
  acts_as_tenant(:account)

  belongs_to :account
  belongs_to :client

  has_many :items, class_name: "CompetencyChecklistItem", dependent: :destroy, inverse_of: :competency_checklist

  before_validation :normalize_period!

  validates :period, presence: true
  validates :period, uniqueness: { scope: [:account_id, :client_id] }

  private

  def normalize_period!
    return if period.blank?

    self.period = period.to_date.beginning_of_month
  end
end
