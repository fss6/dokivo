# frozen_string_literal: true

class BankStatementPolicy < ApplicationPolicy
  def index?
    user.role_member? || user.role_owner?
  end

  class Scope < ApplicationPolicy::Scope
  end
end
