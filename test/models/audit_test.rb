require "test_helper"

class AuditTest < ActiveSupport::TestCase
  setup do
    @account = accounts(:one)
    @user = users(:one)
  end

  test "stores user and account for folder updates" do
    folder = folders(:one)

    Audited.audit_class.as_user(@user) do
      ActsAsTenant.with_tenant(@account) do
        folder.update!(name: "Folder atualizado")
      end
    end

    audit = folder.audits.order(:created_at).last

    assert_equal "update", audit.action
    assert_equal @user, audit.user
    assert_equal @account.id, audit.account_id
  end

  test "excludes ocr_text from bank statement import changes" do
    import = BankStatementImport.create!(
      account: @account,
      client: clients(:alpha),
      institution: institutions(:nubank),
      status: :pending,
      metadata: {},
      ocr_text: "texto inicial"
    )

    Audited.audit_class.as_user(@user) do
      ActsAsTenant.with_tenant(@account) do
        import.update!(ocr_text: "texto alterado", status: :processing)
      end
    end

    audit = import.audits.order(:created_at).last

    refute_includes audit.audited_changes.keys, "ocr_text"
    assert_includes audit.audited_changes.keys, "status"
  end
end
