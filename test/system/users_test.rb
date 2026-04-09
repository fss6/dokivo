require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    login_as users(:owner), scope: :user
    @user = users(:one)
  end

  test "visiting the index" do
    visit users_url
    assert_selector "h1", text: "Usuários"
  end

  test "should create user" do
    visit users_url
    click_on "Novo usuário"

    fill_in "Nome", with: "Usuário sistema"
    fill_in "E-mail", with: "usuario_sistema@example.com"
    select @user.role, from: "Função"
    check "Usuário ativo" if @user.active
    click_on "Criar usuário"

    assert_text "Usuário criado com sucesso."
    assert_text "e-mail"
    click_on "Voltar"
  end

  test "should update User" do
    visit user_url(@user)
    click_on "Editar", match: :first

    fill_in "Nome", with: @user.name
    fill_in "E-mail", with: @user.email
    select @user.role, from: "Função"
    check "Usuário ativo" if @user.active
    click_on "Atualizar usuário"

    assert_text "Usuário atualizado com sucesso."
    click_on "Voltar"
  end

  test "should disable User" do
    active = users(:three)
    visit user_url(active)
    click_on "Desabilitar usuário", match: :first

    within "dialog[open]" do
      click_on "Sim, desabilitar"
    end

    assert_text "Usuário desabilitado com sucesso."
  end

  test "should enable User" do
    visit user_url(@user)
    click_on "Habilitar usuário", match: :first

    within "dialog[open]" do
      click_on "Sim, habilitar"
    end

    assert_text "Usuário habilitado com sucesso."
  end
end
