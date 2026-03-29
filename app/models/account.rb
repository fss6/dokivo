class Account < ApplicationRecord
  belongs_to :plan

  has_many :users, dependent: :destroy

end
