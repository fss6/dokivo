# frozen_string_literal: true

require "test_helper"

class BankStatementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:owner)
    @client = clients(:alpha)
    patch current_client_url, params: { client_id: @client.id }
  end

  test "index" do
    get bank_statements_path
    assert_response :success
  end

  test "index with import_id filter" do
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
      occurred_on: Date.new(2026, 2, 1),
      amount: 2.0,
      transaction_type: :debit,
      description: "Y"
    )
    get bank_statements_path(import_id: import.id)
    assert_response :success
  end

  test "redirects without current client" do
    patch current_client_url, params: { client_id: "" }
    get bank_statements_path
    assert_redirected_to clients_path
  end

  test "create enqueues job and redirects" do
    assert_difference("BankStatementImport.count", 1) do
      assert_enqueued_jobs 1, only: ProcessBankStatementImportJob do
        post bank_statements_path, params: {
          bank_statement_import: {
            institution_id: institutions(:nubank).id,
            file: fixture_file_upload("files/minimal.pdf", "application/pdf")
          }
        }
      end
    end

    import = BankStatementImport.order(:id).last
    assert_redirected_to bank_statement_import_path(import)
  end
end
