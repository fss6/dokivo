# frozen_string_literal: true

class ProcessBankStatementImportJob < ApplicationJob
  queue_as :default

  discard_on ActiveRecord::RecordNotFound

  def perform(bank_statement_import_id)
    import = BankStatementImport.find(bank_statement_import_id)
    ActsAsTenant.with_tenant(import.account) do
      BankStatements::ExtractTransactions.call(import: import)
      AuditEvents::Recorder.call(
        account: import.account,
        event_type: "bank_statement_import.processed",
        subject: import,
        metadata: { bank_statement_import_id: import.id }
      )
    end
  rescue StandardError => e
    if defined?(import) && import&.account
      AuditEvents::Recorder.call(
        account: import.account,
        event_type: "bank_statement_import.failed",
        subject: import,
        metadata: { bank_statement_import_id: import.id, error_class: e.class.name, error_message: e.message }
      )
    end
    raise
  end
end
