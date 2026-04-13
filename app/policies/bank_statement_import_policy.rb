# frozen_string_literal: true

class BankStatementImportPolicy < ApplicationPolicy
  def index?
    user.role_member? || user.role_owner?
  end

  def show?
    user.role_member? || user.role_owner?
  end

  def create?
    user.role_member? || user.role_owner?
  end

  def new?
    create?
  end

  class Scope < ApplicationPolicy::Scope
  end
end
