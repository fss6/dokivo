json.extract! subscription, :id, :account_id, :plan_id, :status, :current_period_end, :trial_ends_at, :canceled_at, :created_at, :updated_at
json.url subscription_url(subscription, format: :json)
