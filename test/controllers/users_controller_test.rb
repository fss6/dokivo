require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: { user: { account_id: @user.account_id, active: @user.active, email: @user.email, name: @user.name, role: @user.role } }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { account_id: @user.account_id, active: @user.active, email: @user.email, name: @user.name, role: @user.role } }
    assert_redirected_to user_url(@user)
  end

  test "should disable user" do
    assert_no_difference("User.count") { delete user_url(@user) }

    assert_redirected_to users_url
    assert_equal false, @user.reload.active
  end
end
