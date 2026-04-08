# frozen_string_literal: true

# Deduplica eventos de webhook (ex.: wamid) por integração.
class IntegrationInboundEvent < ApplicationRecord
  belongs_to :integration_connection

  validates :provider_event_id, presence: true, uniqueness: true
end
