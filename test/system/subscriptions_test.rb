require "application_system_test_case"

class SubscriptionsTest < ApplicationSystemTestCase
  setup do
    @subscription = subscriptions(:one)
  end

  test "visiting the index" do
    visit subscriptions_url
    assert_selector "h1", text: "Assinaturas"
  end

  test "should create subscription" do
    visit subscriptions_url
    click_on "Nova assinatura"

    select @subscription.account_id.to_s, from: "Conta"
    select @subscription.plan_id.to_s, from: "Plano"
    select "Ativa", from: "Status"
    fill_in "Fim do período atual", with: "2026-03-29T10:15"
    fill_in "Trial até", with: "2026-03-30T12:00"
    click_on "Criar assinatura"

    assert_text "Assinatura criada com sucesso."
    click_on "Voltar"
  end

  test "should update Subscription" do
    visit subscription_url(@subscription)
    click_on "Editar", match: :first

    select @subscription.account_id.to_s, from: "Conta"
    select @subscription.plan_id.to_s, from: "Plano"
    select "Ativa", from: "Status"
    fill_in "Fim do período atual", with: "2026-03-29T10:15"
    fill_in "Trial até", with: "2026-03-29T10:15"
    click_on "Atualizar assinatura"

    assert_text "Assinatura atualizada com sucesso."
    click_on "Voltar"
  end

  test "should destroy Subscription" do
    visit subscription_url(@subscription)
    accept_confirm do
      click_on "Excluir assinatura", match: :first
    end

    assert_text "Assinatura excluída com sucesso."
  end
end
