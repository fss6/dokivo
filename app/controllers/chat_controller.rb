# frozen_string_literal: true

class ChatController < ApplicationController
  before_action :authorize_policy

  def index
    account = current_tenant
    user = current_user

    if params[:focus_document_id].present?
      conversation = account.conversations.create!(user: user, title: Conversation::DEFAULT_TITLE)
      redirect_to account_conversation_path(
        account,
        conversation,
        focus_document_id: params[:focus_document_id]
      )
      return
    end

    redirect_to account_conversations_path(account)
  end

  private

  def authorize_policy
    authorize Conversation
  end
end
