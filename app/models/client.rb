# frozen_string_literal: true

class Client < ApplicationRecord
  acts_as_tenant(:account)

  has_many :folders, dependent: :nullify

  normalizes :tax_id, with: ->(v) { v.to_s.strip.presence }
  normalizes :name, with: ->(v) { v.to_s.strip }
  normalizes :email, with: ->(v) { v.to_s.strip.presence }
  normalizes :phone, with: ->(v) { v.to_s.strip.presence }

  validates :name, presence: true
  validates :tax_id, uniqueness: { scope: :account_id }, allow_blank: true
end
