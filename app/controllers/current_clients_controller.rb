# frozen_string_literal: true

class CurrentClientsController < ApplicationController
  def update
    authorize Client, :index?

    if params[:client_id].blank?
      session.delete(:current_client_id)
    else
      client = Client.find_by(id: params[:client_id])
      if client
        session[:current_client_id] = client.id
      else
        session.delete(:current_client_id)
        redirect_back fallback_location: root_path, alert: "Cliente não encontrado.", status: :see_other
        return
      end
    end

    redirect_to redirect_target, status: :see_other
  end

  private

  def redirect_target
    return_to = params[:return_to].to_s
    return return_to if return_to.present? && return_to.start_with?("/")

    request.referer.presence || root_path
  end
end
