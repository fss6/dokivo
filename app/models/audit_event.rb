class AuditEvent < ApplicationRecord
  belongs_to :account
  belongs_to :user, optional: true
  belongs_to :subject, polymorphic: true

  validates :event_type, presence: true
end
