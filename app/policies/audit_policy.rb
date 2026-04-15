# frozen_string_literal: true

class AuditPolicy < ApplicationPolicy
  def index?
    user.role_owner? || user.role_administrator?
  end
end
