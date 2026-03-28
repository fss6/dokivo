require "application_system_test_case"

class PlansTest < ApplicationSystemTestCase
  setup do
    @plan = plans(:one)
  end

  test "visiting the index" do
    visit plans_url
    assert_selector "h1", text: "Ativos adicionados recentemente"
  end

  test "should create plan" do
    visit plans_url
    click_on "Novo plano"

    fill_in "Nome", with: @plan.name
    fill_in "Preço", with: @plan.price
    fill_in "Status", with: @plan.status
    click_on "Criar plano"

    assert_text "Plano criado com sucesso."
    click_on "Voltar"
  end

  test "should update Plan" do
    visit plan_url(@plan)
    click_on "Editar", match: :first

    fill_in "Nome", with: @plan.name
    fill_in "Preço", with: @plan.price
    fill_in "Status", with: @plan.status
    click_on "Atualizar plano"

    assert_text "Plano atualizado com sucesso."
    click_on "Voltar"
  end

  test "should destroy Plan" do
    visit plan_url(@plan)
    accept_confirm do
      click_on "Excluir plano", match: :first
    end

    assert_text "Plano excluído com sucesso."
  end
end
