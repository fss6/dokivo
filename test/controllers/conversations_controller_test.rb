# frozen_string_literal: true

require "test_helper"

class ConversationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = accounts(:one)
    @conversation = conversations(:one)
  end

  test "destroy removes conversation and redirects" do
    assert_difference("Conversation.count", -1) do
      delete account_conversation_url(@account, @conversation)
    end

    assert_redirected_to account_conversations_url(@account)
  end
end
