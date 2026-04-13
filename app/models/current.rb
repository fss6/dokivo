# frozen_string_literal: true

# Estado por requisição (thread-local), resetado entre requests pelo Rails.
# O cliente "persistido" continua na sessão; aqui só expomos o objeto carregado.
#
# @see https://api.rubyonrails.org/classes/ActiveSupport/CurrentAttributes.html
class Current < ActiveSupport::CurrentAttributes
  attribute :client
end
