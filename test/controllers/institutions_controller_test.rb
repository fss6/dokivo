# frozen_string_literal: true

require "test_helper"

class InstitutionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:owner)
  end

  test "index" do
    get institutions_path
    assert_response :success
  end
end
