# frozen_string_literal: true

require "test_helper"

class BankStatementImportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:owner)
    @client = clients(:alpha)
    patch current_client_url, params: { client_id: @client.id }
  end

  test "show" do
    import = BankStatementImport.create!(
      account: accounts(:one),
      client: @client,
      institution: institutions(:nubank),
      status: :completed,
      metadata: {}
    )
    BankStatement.create!(
      account: accounts(:one),
      client: @client,
      bank_statement_import: import,
      institution: institutions(:nubank),
      occurred_on: Date.new(2026, 1, 1),
      amount: 1.0,
      transaction_type: :credit,
      description: "X"
    )
    get bank_statement_import_path(import)
    assert_response :success
  end

  test "original redirects to Active Storage when file attached" do
    import = BankStatementImport.create!(
      account: accounts(:one),
      client: @client,
      institution: institutions(:nubank),
      status: :completed,
      metadata: {}
    )
    import.file.attach(
      io: StringIO.new(File.binread(Rails.root.join("test/fixtures/files/minimal.pdf"))),
      filename: "extrato.pdf",
      content_type: "application/pdf"
    )

    get original_bank_statement_import_path(import)
    assert_response :redirect
    assert_match %r{/rails/active_storage/}, response.redirect_url
  end

  test "original redirects to import show when file missing" do
    import = BankStatementImport.create!(
      account: accounts(:one),
      client: @client,
      institution: institutions(:nubank),
      status: :completed,
      metadata: {}
    )

    get original_bank_statement_import_path(import)
    assert_redirected_to bank_statement_import_path(import)
  end

  test "redirects to clients without current client in session" do
    patch current_client_url, params: { client_id: "" }
    get bank_statement_import_path(
      BankStatementImport.create!(
        account: accounts(:one),
        client: @client,
        institution: institutions(:nubank),
        status: :pending,
        metadata: {}
      )
    )
    assert_redirected_to clients_path
  end
end
