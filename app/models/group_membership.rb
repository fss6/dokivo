class GroupMembership < ApplicationRecord
  belongs_to :group
  belongs_to :user

  validates :user_id, uniqueness: { scope: :group_id }
  validate :user_belongs_to_same_account_as_group

  private

  def user_belongs_to_same_account_as_group
    return if group.blank? || user.blank?

    return if user.account_id == group.account_id

    errors.add(:user, "deve pertencer à mesma conta do grupo")
  end
end
