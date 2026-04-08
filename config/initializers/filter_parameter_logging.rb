# Be sure to restart your server when you modify this file.

# Configure parameters to be partially matched (e.g. passw matches password) and filtered from the log file.
# Use this to limit dissemination of sensitive information.
# See the ActiveSupport::ParameterFilter documentation for supported notations and behaviors.
# Evitar :token genérico: em Rails filtra qualquer chave que contenha "token" (ex.: hub.verify_token,
# verify_token), o que mascara logs e dificulta webhooks. Preferir nomes explícitos.
Rails.application.config.filter_parameters += [
  :passw,
  :email,
  :secret,
  :access_token,
  :refresh_token,
  :authenticity_token,
  :_key,
  :crypt,
  :salt,
  :certificate,
  :otp,
  :ssn,
  :cvv,
  :cvc
]
