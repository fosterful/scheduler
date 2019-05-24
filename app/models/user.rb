# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable, :lockable, validate_on_invite: true

  COORDINATOR   = 'coordinator'
  SOCIAL_WORKER = 'social_worker'
  VOLUNTEER     = 'volunteer'
  ADMIN         = 'admin'

  ROLES = [COORDINATOR, SOCIAL_WORKER, VOLUNTEER, ADMIN].freeze
  PROFILE_ATTRS = [:first_name,
                   :last_name,
                   :phone,
                   :time_zone,
                   :race_id,
                   :first_language_id,
                   :second_language_id,
                   { age_range_ids: [] },
                   :birth_date,
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
  has_many :served_needs, -> { distinct }, through: :shifts, class_name: 'Need', source: 'need'

  belongs_to :first_language, optional: true, class_name: 'Language'
  belongs_to :second_language, optional: true, class_name: 'Language'

  validates :first_name, :last_name, :phone, presence: true, if: :invitation_accepted_at?

  validates :phone, telephone_number: { country: :us, types: %i(mobile) }, if: :phone?

  validates :birth_date, :resident_since, :discovered_omd_by, :race,
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

  scope :coordinators, -> { where(role: COORDINATOR) }
  scope :social_workers, -> { where(role: SOCIAL_WORKER) }
  scope :volunteers, -> {  where(role: VOLUNTEER) }
  scope :volunteerable, -> { volunteers.or(coordinators) }
  scope :schedulers, -> { coordinators.or(social_workers) }
  scope :with_phone, -> { where.not(phone: nil) }

  scope :speaks_language, ->(language) { where(first_language: language).or(where(second_language: language)) }

  def self.shifts_by_user
    joins(:shifts).group('users.id')
  end

  def self.volunteerable_by_language
    volunteerable.joins('INNER JOIN languages ON languages.id IN (users.first_language_id, users.second_language_id)').group('languages.name')
  end

  def self.total_volunteers_by_spoken_language
    volunteerable_by_language.count
  end

  def self.total_volunteer_minutes_by_user
    shifts_by_user.sum('shifts.duration')
  end

  def self.available_within(start_at, end_at)
    sql = <<~SQL
      LEFT OUTER JOIN blockouts
      ON blockouts.user_id = users.id
      AND tsrange(start_at, end_at) && tsrange('#{start_at.to_s(:db)}', '#{end_at.to_s(:db)}')
    SQL

    joins(sql)
      .where(blockouts: { id: nil })
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
    name.presence || email
  end

  def scheduler?
    role.in? [COORDINATOR, SOCIAL_WORKER, ADMIN]
  end

  private

  def require_volunteer_profile_attributes?
    (volunteer? || coordinator?) && invitation_accepted_at?
  end
end
