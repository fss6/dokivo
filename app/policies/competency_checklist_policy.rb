class CompetencyChecklistPolicy < ApplicationPolicy
  def show?
    user.role_member? || user.role_owner?
  end

  def refresh_receipts?
    show?
  end

  def create_template_item?
    show?
  end

  def mark_validated?
    show?
  end

  def mark_pending?
    show?
  end

  def remove_item?
    show?
  end

  def attach_document?
    show?
  end

  def detach_document?
    show?
  end
end
