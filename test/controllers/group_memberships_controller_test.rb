require "test_helper"

class GroupMembershipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group = groups(:one)
    @user = users(:three)
  end

  test "should create membership" do
    assert_difference("GroupMembership.count") do
      post group_memberships_url(@group), params: { group_membership: { user_id: @user.id } }
    end

    assert_redirected_to group_url(@group)
  end

  test "should destroy membership" do
    membership = group_memberships(:one)

    assert_difference("GroupMembership.count", -1) do
      delete group_membership_url(membership.group, membership)
    end

    assert_redirected_to group_url(membership.group)
  end
end
