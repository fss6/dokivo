require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "inactive user is not active for authentication" do
    user = users(:one)

    assert_not user.active_for_authentication?
  end

  test "active user is active for authentication" do
    user = users(:three)

    assert user.active_for_authentication?
  end
end
