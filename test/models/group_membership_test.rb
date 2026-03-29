require "test_helper"

class GroupMembershipTest < ActiveSupport::TestCase
  setup do
    @group = groups(:one)
    @user = users(:one)
    @other_account_user = users(:two)
  end

  test "requires unique user per group" do
    duplicate = GroupMembership.new(group: @group, user: @user)
    assert_not duplicate.valid?
    assert duplicate.errors.of_kind?(:user_id, :taken)
  end

  test "user must belong to same account as group" do
    membership = GroupMembership.new(group: @group, user: @other_account_user)
    assert_not membership.valid?
    assert_includes membership.errors[:user], "deve pertencer à mesma conta do grupo"
  end
end
