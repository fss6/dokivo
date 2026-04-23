# frozen_string_literal: true

require "test_helper"

class MonthlyCollectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:owner)
    @client = clients(:alpha)
    @period = Date.new(2026, 4, 1)

    patch current_client_url, params: { client_id: @client.id }
  end

  test "should remove competency and redirect to list" do
    checklist = CompetencyChecklist.create!(
      account: users(:owner).account,
      client: @client,
      period: @period
    )

    assert_difference("CompetencyChecklist.count", -1) do
      delete monthly_collection_url(@period.strftime("%Y-%m"))
    end

    assert_redirected_to monthly_collections_path
    follow_redirect!
    assert_includes response.body, "Competência removida com sucesso."
    assert_not CompetencyChecklist.exists?(checklist.id)
  end
end
