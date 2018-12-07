class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable, :lockable

  ROLES = %w[volunteer coordinator social_worker admin].freeze
  REGISTERABLE_ROLES = %w[volunteer coordinator social_worker].freeze
  validates :role, inclusion: { in: ROLES, message: '%{value} is not a valid role' }

  ROLES.each do |role|
    define_method "#{role}?" do
      self.role === role
    end
  end
end
