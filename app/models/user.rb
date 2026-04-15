class User < ApplicationRecord
  acts_as_tenant(:account)
  attribute :active, :boolean, default: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable
  belongs_to :account

  has_many :conversations, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :audit_events, dependent: :nullify
  has_many :validated_competency_checklist_items, class_name: "CompetencyChecklistItem", foreign_key: :validated_by_user_id, dependent: :nullify, inverse_of: :validated_by_user
  has_many :group_memberships, dependent: :destroy
  has_many :groups, through: :group_memberships

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { scope: :account_id }
  validates :role, presence: true
  validates :active, inclusion: { in: [ true, false ] }

  enum :role, {
    member: "member", # Membro da conta
    owner: "owner", # Administrador da conta
    administrator: "administrator" # Administrador do SaaS
  }, prefix: true

  def active_for_authentication?
    super && active?
  end

  def enabled?
    active?
  end

  # Satisfies Devise validations on create; pair with +send_reset_password_instructions+ so the
  # user sets their own password (admin-created users).
  def assign_initial_random_password!
    self.password = self.password_confirmation = SecureRandom.hex(32)
  end

  def role_label
    I18n.t("activerecord.enums.user.role.#{role}")
  end

  def self.role_options_for_select(administrator:)
    keys = administrator ? roles.keys : roles.keys - [ "administrator" ]
    keys.map { |key| [ I18n.t("activerecord.enums.user.role.#{key}"), key ] }
  end
end
