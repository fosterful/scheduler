# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable, :lockable, validate_on_invite: true

  ROLES = %w[volunteer coordinator social_worker admin].freeze
  REGISTERABLE_ROLES = %w[volunteer coordinator social_worker].freeze
  PROFILE_ATTRS = [:first_name,
                   :last_name,
                   :time_zone,
                   :race_id,
                   :first_language_id,
                   {age_range_ids: []},
                   :birth_date,
                   :phone,
                   :resident_since,
                   :discovered_omd_by,
                   :medical_limitations,
                   :medical_limitations_desc,
                   :conviction,
                   :conviction_desc].freeze

  has_one :address, as: :addressable, dependent: :destroy
  has_and_belongs_to_many :offices
  has_many :blockouts, dependent: :destroy
  belongs_to :race, optional: true
  has_and_belongs_to_many :age_ranges
  has_many :needs, dependent: :restrict_with_error
  has_many :shifts, dependent: :restrict_with_error
  has_many :served_needs,  -> { distinct }, through: :shifts, class_name: 'Need', source: 'need'

  belongs_to :first_language, optional: true, class_name: 'Language'
  belongs_to :second_language, optional: true, class_name: 'Language'

  validates :first_name, :last_name, presence: true, if: :invitation_accepted_at?

  validates :birth_date, :phone, :resident_since, :discovered_omd_by, :race,
            :first_language,
            presence: true, if: :require_volunteer_profile_attributes?

  validates :medical_limitations, :conviction,
            inclusion: { in: [true, false], message: "can't be blank" },
            if: :require_volunteer_profile_attributes?

  validates :medical_limitations_desc,
            presence: true,
            if: -> { require_volunteer_profile_attributes? && medical_limitations? }

  validates :conviction_desc,
            presence: true,
            if: -> { require_volunteer_profile_attributes? && conviction? }

  validates :role, inclusion: { in: ROLES, message: '%{value} is not a valid role' }
  validates :time_zone, presence: true, if: :invitation_accepted_at?
  validate :has_at_least_one_office
  validate :has_at_least_one_age_range, if: :require_volunteer_profile_attributes?

  scope :volunteers, -> { where(role: 'volunteer').or(where(role: 'coordinator')) }

  scope :total_volunteer_minutes, -> { joins(:shifts).group('users.id').sum('shifts.duration') }
  scope :children_served_by_user, -> { joins(shifts: :need).group('needs.id, users.id').select('needs.id, users.id, needs.number_of_children') }

  def self.available_within(start_at, end_at)
    sql = <<~SQL
      LEFT OUTER JOIN blockouts
      ON blockouts.user_id = users.id
      AND tsrange(start_at, end_at) && tsrange('#{start_at.to_s(:db)}', '#{end_at.to_s(:db)}')
    SQL

    joins(sql)
      .where(blockouts: { id: nil })
  end

  def self.speaks_language(language)
    where(first_language: language).or(where(second_language: language))
  end

  def foobar
    served_needs.sum(:number_of_children)
  end

  def has_at_least_one_office
    errors.add(:base, 'At least one office assignment is required') if offices.blank?
  end

  def has_at_least_one_age_range
    errors.add(:base, 'At least one age range selection is required') if age_ranges.blank?
  end

  ROLES.each do |role|
    define_method "#{role}?" do
      self.role === role
    end
  end

  def name
    name = "#{first_name} #{last_name}"
    name.present? ? name : email
  end

  def scheduler?
    role.in? %w[coordinator social_worker]
  end

  private

  def require_volunteer_profile_attributes?
    (volunteer? || coordinator?) && invitation_accepted_at?
  end
end
