# frozen_string_literal: true

class ClientsController < ApplicationController
  before_action :set_client, only: %i[show edit update destroy]
  before_action :authorize_policy

  def index
    @clients = Client.order(:name)
  end

  def show
  end

  def new
    @client = Client.new
  end

  def edit
  end

  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        format.html { redirect_to @client, notice: "Cliente criado com sucesso." }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to @client, notice: "Cliente atualizado com sucesso.", status: :see_other }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if session[:current_client_id].to_i == @client.id
      session.delete(:current_client_id)
      Current.client = nil
    end
    @client.destroy!

    respond_to do |format|
      format.html { redirect_to clients_path, notice: "Cliente excluído com sucesso.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def authorize_policy
    authorize(@client || Client)
  end

  def set_client
    @client = Client.find(params.expect(:id))
  end

  def client_params
    params.expect(client: [:name, :tax_id, :email, :phone, :notes])
  end
end
