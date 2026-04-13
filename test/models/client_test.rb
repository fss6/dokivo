# frozen_string_literal: true

require "test_helper"

class ClientTest < ActiveSupport::TestCase
  test "requires name" do
    ActsAsTenant.with_tenant(accounts(:one)) do
      c = Client.new(name: "   ")
      assert_not c.valid?
    end
  end
end
