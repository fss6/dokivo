# frozen_string_literal: true

class BankStatementPolicy < ApplicationPolicy
  def index?
    user.role_member? || user.role_owner?
  end

  def create?
    index?
  end

  def update?
    index?
  end

  def destroy?
    index?
  end

  class Scope < ApplicationPolicy::Scope
  end
end
