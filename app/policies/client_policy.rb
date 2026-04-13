# frozen_string_literal: true

class ClientPolicy < ApplicationPolicy
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

  def update?
    user.role_member? || user.role_owner?
  end

  def edit?
    update?
  end

  def destroy?
    user.role_member? || user.role_owner?
  end

  class Scope < ApplicationPolicy::Scope
  end
end
