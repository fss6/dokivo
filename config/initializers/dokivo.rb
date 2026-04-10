# frozen_string_literal: true

module Dokivo
  # Public signup is off in production by default; set DISABLE_SIGNUP=false in .env to allow it.
  def self.signup_disabled?
    ActiveModel::Type::Boolean.new.cast(
      ENV.fetch("DISABLE_SIGNUP", Rails.env.production? ? "true" : "false")
    )
  end
end
