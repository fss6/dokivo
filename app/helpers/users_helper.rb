# frozen_string_literal: true

module UsersHelper
  include AppConfirmModalHelper

  # Modal de confirmação para desabilitar (DELETE) — use quando `user.enabled?`.
  def user_disable_modal_data(user)
    app_confirm_modal_open_data(url: user_path(user), item_label: user.name)
  end

  # Modal de confirmação para habilitar (POST enable) — use quando `user.enabled?` é false.
  def user_enable_modal_data(user)
    app_confirm_modal_open_data(
      url: enable_user_path(user),
      item_label: user.name,
      http_method: "post",
      heading: t("users.confirm_modal_enable.heading"),
      body_prefix: t("users.confirm_modal_enable.body_prefix"),
      body_suffix: t("users.confirm_modal_enable.body_suffix"),
      confirm_text: t("users.confirm_modal_enable.confirm"),
      confirm_variant: "primary"
    )
  end
end
