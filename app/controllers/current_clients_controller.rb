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

    redirect_back fallback_location: root_path, status: :see_other
  end
end
