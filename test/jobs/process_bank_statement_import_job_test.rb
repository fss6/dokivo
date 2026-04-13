# frozen_string_literal: true

require "test_helper"

class ProcessBankStatementImportJobTest < ActiveJob::TestCase
  setup do
    @import = BankStatementImport.create!(
      account: accounts(:one),
      client: clients(:alpha),
      institution: institutions(:nubank),
      status: :pending,
      metadata: {}
    )
    @import.file.attach(
      io: StringIO.new(Rails.root.join("test/fixtures/files/minimal.pdf").read),
      filename: "minimal.pdf",
      content_type: "application/pdf"
    )
  end

  test "runs extract service" do
    MistralOcr::ExtractContent.stub :call, { text: "linha extrato", response: { "model" => "mistral-ocr-latest" } } do
      Openai::Completion.stub :call, '[{"date":"2026-01-01","description":"Pagamento X","amount":10.5,"type":"credit"}]' do
        ProcessBankStatementImportJob.perform_now(@import.id)
      end
    end

    @import.reload
    assert @import.completed?
    assert_equal 1, @import.bank_statements.count
    line = @import.bank_statements.first
    assert_equal "Pagamento X", line.description
    assert_equal institutions(:nubank).id, line.institution_id
  end
end
