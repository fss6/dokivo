require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:owner)
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
    assert_emails 1 do
      assert_difference("User.count") do
        post users_url, params: { user: { active: true, email: "novo_convite@example.com", name: "Novo", role: "member" } }
      end
    end

    assert_redirected_to user_url(User.last)
    assert_match(/e-mail|senha/i, flash[:notice].to_s)
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
    patch user_url(@user), params: { user: { active: @user.active, email: @user.email, name: @user.name, role: @user.role } }
    assert_redirected_to user_url(@user)
  end

  test "cannot disable own user" do
    assert_raises(Pundit::NotAuthorizedError) do
      delete user_url(users(:owner))
    end
  end

  test "should disable user from index returns to index" do
    active = users(:three)
    assert active.active?

    assert_no_difference("User.count") do
      delete user_url(active), headers: { "Referer" => users_url }
    end

    assert_redirected_to users_url
    assert_equal false, active.reload.active
  end

  test "should disable user from show returns to show" do
    active = users(:three)
    delete user_url(active), headers: { "Referer" => user_url(active) }

    assert_redirected_to user_url(active)
    assert_equal false, active.reload.active
  end

  test "should enable user without referer falls back to user show" do
    inactive = users(:one)
    assert_not inactive.active?

    post enable_user_url(inactive)

    assert_redirected_to user_url(inactive)
    assert inactive.reload.active?
  end

  test "should enable user from index returns to index" do
    inactive = users(:one)
    inactive.update_column(:active, false)

    post enable_user_url(inactive), headers: { "Referer" => users_url }

    assert_redirected_to users_url
    assert inactive.reload.active?
  end
end
