# frozen_string_literal: true

class IntegrationConnectionsController < ApplicationController
  before_action :set_account
  before_action :set_connection, only: %i[edit update destroy test_connection]
  before_action :authorize_policy

  def index
    @connections = policy_scope(@account.integration_connections).order(:provider, :created_at)
  end

  def new
    @connection = @account.integration_connections.build(provider: "whatsapp_cloud")
  end

  def create
    @connection = @account.integration_connections.build(connection_params.merge(provider: "whatsapp_cloud"))

    if @connection.save
      redirect_to account_integration_connections_path(@account),
                    notice: "Integração criada. Webhook (POST/GET): #{webhooks_whatsapp_url}.",
                    status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    attrs = connection_params
    attrs.delete(:access_token) if attrs[:access_token].to_s.strip.blank?

    if @connection.update(attrs)
      redirect_to account_integration_connections_path(@account), notice: "Integração atualizada.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @connection.destroy
    redirect_to account_integration_connections_path(@account), notice: "Integração removida.", status: :see_other
  end

  def test_connection
    result = Integrations::Whatsapp::ConnectionTester.call(@connection)
    if result.success?
      redirect_back fallback_location: account_integration_connections_path(@account),
                    notice: result.message,
                    status: :see_other
    else
      redirect_back fallback_location: account_integration_connections_path(@account),
                    alert: result.message,
                    status: :see_other
    end
  end

  private

  def authorize_policy
    authorize(@connection || IntegrationConnection)
  end

  def set_account
    @account = Account.find(params.expect(:account_id))
    unless @account.id == current_user.account_id
      raise ActiveRecord::RecordNotFound
    end
  end

  def set_connection
    @connection = @account.integration_connections.find(params.expect(:id))
  end

  def connection_params
    raw = params.require(:integration_connection).permit(
      :phone_number_id,
      :display_phone_number,
      :verify_token,
      :access_token,
      :active
    )
    raw[:active] = ActiveModel::Type::Boolean.new.cast(raw[:active]) if raw.key?(:active)
    raw
  end
end
