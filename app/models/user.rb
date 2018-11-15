class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable, :lockable

  ROLES = %w[volunteer coordinator admin].freeze
  validates :role, inclusion: { in: ROLES, message: '%{value} is not a valid role' }
end
