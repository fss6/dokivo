# frozen_string_literal: true

module AppConfirmModalHelper
  # Atributos + ação Stimulus para abrir o modal definido no mesmo ancestral com data-controller="app-confirm-modal".
  # @param url [String] URL do form de confirmação (ex.: user_path(user), folder_path(folder))
  # @param item_label [String, nil] texto exibido em destaque no corpo do modal (nome do recurso)
  def app_confirm_modal_open_data(url:, item_label: nil, **extra)
    {
      action: "click->app-confirm-modal#open",
      app_confirm_modal_url_param: url,
      app_confirm_modal_item_label_param: item_label
    }.merge(extra)
  end
end
