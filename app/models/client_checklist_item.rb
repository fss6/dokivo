class ClientChecklistItem < ApplicationRecord
  acts_as_tenant(:account)

  belongs_to :account
  belongs_to :client

  has_many :competency_checklist_items, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :position, numericality: { greater_than_or_equal_to: 0 }

  scope :active_only, -> { where(active: true).order(:position, :id) }

  def match_terms
    value = read_attribute(:match_terms)
    value.is_a?(Array) ? value : []
  end
end
