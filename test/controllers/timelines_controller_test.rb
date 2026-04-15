# frozen_string_literal: true

require "test_helper"

class TimelinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:owner)

    @account = users(:owner).account
    @owner = users(:owner)
    @client = clients(:alpha)
    @period = Date.current.beginning_of_month
    @period_name = @period.strftime("%Y-%m")
  end

  test "should redirect when current client is missing" do
    get timeline_url

    assert_redirected_to clients_path
    follow_redirect!
    assert_includes response.body, "Selecione um cliente para continuar."
  end

  test "should render timeline for current client" do
    Folder.create!(account: @account, client: @client, name: @period_name, visible: false)
    patch current_client_url, params: { client_id: @client.id }

    get timeline_url

    assert_response :success
    assert_includes response.body, "Timeline"
    assert_includes response.body, @client.name
  end

  test "should include received documents and pending items" do
    checklist = CompetencyChecklist.create!(account: @account, client: @client, period: @period)
    CompetencyChecklistItem.create!(
      competency_checklist: checklist,
      name_snapshot: "NFs de servico restantes",
      state: :pending
    )
    folder = Folder.create!(account: @account, client: @client, name: @period_name, visible: false)
    Document.create!(
      account: @account,
      user: @owner,
      folder: folder,
      status: :processed,
      created_at: 1.day.ago,
      updated_at: 1.day.ago
    )
    patch current_client_url, params: { client_id: @client.id }

    get timeline_period_url(@period_name)

    assert_response :success
    assert_includes response.body, "Recebido"
    assert_includes response.body, "NFs de servico restantes"
    assert_includes response.body, "Pendente"
  end

  test "should redirect on invalid period" do
    patch current_client_url, params: { client_id: @client.id }

    get timeline_period_url("2026-99")

    assert_redirected_to timeline_path
    follow_redirect!
    assert_includes response.body, "Competencia invalida."
  end
end
