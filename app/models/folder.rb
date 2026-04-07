class Folder < ApplicationRecord
  acts_as_tenant(:account)

  has_many :documents, dependent: :destroy
end
