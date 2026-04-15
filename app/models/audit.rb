# frozen_string_literal: true

class Audit < Audited::Audit
  belongs_to :account, optional: true

  before_validation :assign_account_id, on: :create
  before_validation :normalize_audited_changes_for_yaml, on: :create

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

  # Evita falhas de serialização YAML segura (Psych::DisallowedClass),
  # convertendo tipos não escalares (ex.: Date/Time) em String.
  def normalize_audited_changes_for_yaml
    return if audited_changes.blank?

    self.audited_changes = normalize_yaml_value(audited_changes)
  end

  def normalize_yaml_value(value)
    case value
    when Hash
      value.transform_values { |entry| normalize_yaml_value(entry) }
    when Array
      value.map { |entry| normalize_yaml_value(entry) }
    when Date, Time, DateTime, ActiveSupport::TimeWithZone
      value.iso8601
    else
      value
    end
  end
end
