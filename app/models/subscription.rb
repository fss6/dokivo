class Subscription < ApplicationRecord
  belongs_to :account
  belongs_to :plan

  enum :status, {
    trialing: 'trialing',
    active: 'active',
    past_due: 'past_due',
    unpaid: 'unpaid',
    canceled: 'canceled',
    expired: 'expired'
  }

  def active?
    %w[trialing active].include?(status)
  end

  def blocked?
    %w[unpaid expired].include?(status)
  end

end
