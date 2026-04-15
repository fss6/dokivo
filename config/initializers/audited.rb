# frozen_string_literal: true

Audited.current_user_method = :current_user
Audited.audit_class = "Audit"
Audited.ignored_attributes = %w[created_at updated_at].freeze
