class User < ApplicationRecord
  acts_as_tenant(:account)
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :account

  has_many :conversations, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :group_memberships, dependent: :destroy
  has_many :groups, through: :group_memberships

  enum :role, {
    member: "member", # Membro da conta
    owner: "owner", # Administrador da conta
    administrator: "administrator" # Administrador do SaaS
  }, prefix: true

  def active_for_authentication?
    super && active?
  end
end
