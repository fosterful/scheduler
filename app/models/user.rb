class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable, :lockable, validate_on_invite: true

  ROLES = %w[volunteer coordinator social_worker admin].freeze
  REGISTERABLE_ROLES = %w[volunteer coordinator social_worker].freeze
  validates :role, inclusion: { in: ROLES, message: '%{value} is not a valid role' }

  has_one :address, as: :addressable
  has_and_belongs_to_many :offices

  validate :has_at_least_one_office

  def has_at_least_one_office
    errors.add(:base, 'At least one office assignment is required') if offices.blank?
  end

  ROLES.each do |role|
    define_method "#{role}?" do
      self.role === role
    end
  end
end
