class Folder < ApplicationRecord
  acts_as_tenant(:account)
  audited on: %i[create update destroy], except: %i[created_at updated_at]

  belongs_to :client, optional: true

  has_many :documents, dependent: :destroy

  scope :for_nav_client, ->(client) {
    if client
      where(client_id: client.id)
    else
      all
    end
  }
end
