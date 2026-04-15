# frozen_string_literal: true

class Audit < Audited::Audit
  belongs_to :account, optional: true

  before_validation :assign_account_id, on: :create

  private

  def assign_account_id
    return if account_id.present?

    self.account_id = auditable_account_id || associated_account_id || ActsAsTenant.current_tenant&.id
  end

  def auditable_account_id
    auditable&.respond_to?(:account_id) ? auditable.account_id : nil
  end

  def associated_account_id
    associated&.respond_to?(:account_id) ? associated.account_id : nil
  end
end
