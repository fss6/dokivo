# frozen_string_literal: true

module AuditEvents
  class Recorder
    def self.call(account:, event_type:, subject:, user: nil, metadata: {})
      AuditEvent.create!(
        account: account,
        user: user,
        event_type: event_type,
        subject: subject,
        metadata: metadata || {}
      )
    end
  end
end
