class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.references :account, null: false, foreign_key: true
      t.references :plan, null: false, foreign_key: true
      t.string :status
      t.datetime :current_period_end
      t.datetime :trial_ends_at
      t.datetime :canceled_at

      t.timestamps
    end
  end
end
