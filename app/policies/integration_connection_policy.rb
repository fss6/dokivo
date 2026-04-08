# frozen_string_literal: true

class IntegrationConnectionPolicy < ApplicationPolicy
  def index?
    user.role_owner?
  end

  def show?
    false
  end

  def create?
    user.role_owner?
  end

  def new?
    create?
  end

  def update?
    user.role_owner?
  end

  def edit?
    update?
  end

  def destroy?
    user.role_owner?
  end

  def test_connection?
    user.role_owner?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope
    end
  end
end
