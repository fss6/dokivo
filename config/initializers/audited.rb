# frozen_string_literal: true

Audited.current_user_method = :current_user
Audited.audit_class = "Audit"
Audited.ignored_attributes = %w[created_at updated_at].freeze

# Audited serializa `audited_changes` em YAML.
# Em Rails recentes, classes precisam estar permitidas explicitamente.
ActiveRecord.yaml_column_permitted_classes = (
  ActiveRecord.yaml_column_permitted_classes + [Date]
).uniq
