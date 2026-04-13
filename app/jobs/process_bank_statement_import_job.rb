# frozen_string_literal: true

class ProcessBankStatementImportJob < ApplicationJob
  queue_as :default

  discard_on ActiveRecord::RecordNotFound

  def perform(bank_statement_import_id)
    import = BankStatementImport.find(bank_statement_import_id)
    ActsAsTenant.with_tenant(import.account) do
      BankStatements::ExtractTransactions.call(import: import)
    end
  end
end
