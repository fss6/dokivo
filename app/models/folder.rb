class Folder < ApplicationRecord
  acts_as_tenant(:account)

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
