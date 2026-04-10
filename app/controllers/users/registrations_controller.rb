# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  layout "devise"
  before_action :redirect_if_signup_disabled, only: %i[new create]

  private

  def redirect_if_signup_disabled
    return unless Dokivo.signup_disabled?

    redirect_to new_user_session_path, alert: I18n.t("dokivo.signup.disabled")
  end
end
