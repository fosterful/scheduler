# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable, :lockable, validate_on_invite: true

  ADMIN         = 'admin'
  COORDINATOR   = 'coordinator'
  SOCIAL_WORKER = 'social_worker'
  VOLUNTEER     = 'volunteer'

  ROLES         = [ADMIN, COORDINATOR, SOCIAL_WORKER, VOLUNTEER].freeze
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
                   :conviction_desc,
                   { office_notification_ids: [] }].freeze

  has_one :address, as: :addressable, dependent: :destroy
  has_many :blockouts, dependent: :destroy
  belongs_to :race, optional: true
  has_and_belongs_to_many :age_ranges
  has_many :announcements,
           dependent:   :restrict_with_error,
           foreign_key: 'author_id'
  has_many :needs, dependent: :restrict_with_error
  has_many :shifts, dependent: :restrict_with_error
  has_many :served_needs, -> { distinct },
           through:    :shifts,
           class_name: 'Need',
           source:     'need'
  has_many :office_users, dependent: :destroy
  has_many :offices, through: :office_users
  has_and_belongs_to_many :social_worker_needs,
                          class_name:              'Need',
                          join_table:              'needs_social_workers',
                          foreign_key:             'social_worker_id',
                          association_foreign_key: 'need_id'

  belongs_to :first_language,
             optional:   true,
             class_name: 'Language',
             inverse_of: :primary_speakers

  belongs_to :second_language,
             optional:   true,
             class_name: 'Language',
             inverse_of: :secondary_speakers

  validates :first_name,
            :last_name,
            :phone,
            presence: true,
            if:       :invitation_accepted_at?

  validates :phone,
            telephone_number: { country: :us, types: %i(mobile) },
            if:               :phone?

  validates :birth_date,
            :discovered_omd_by,
            :first_language,
            :race,
            :resident_since,
            presence: true,
            if:       :require_volunteer_profile_attributes?

  validates :conviction,
            :medical_limitations,
            inclusion: { in: [true, false], message: "can't be blank" },
            if:        :require_volunteer_profile_attributes?

  validates :medical_limitations_desc,
            presence: true,
            if:       -> { require_volunteer_profile_attributes? && medical_limitations? }

  validates :conviction_desc,
            presence: true,
            if:       -> { require_volunteer_profile_attributes? && conviction? }

  validates :role,
            inclusion: { in: ROLES, message: '%<value> is not a valid role' }
  validates :time_zone, presence: true, if: :invitation_accepted_at?
  validate :at_least_one_office
  validate :at_least_one_age_range,
           if: :require_volunteer_profile_attributes?

  scope :coordinators, -> { where(role: COORDINATOR) }
  scope :social_workers, -> { where(role: SOCIAL_WORKER) }
  scope :volunteers, -> { where(role: VOLUNTEER) }
  scope :volunteerable, -> { volunteers.or(coordinators) }
  scope :notifiable, -> { volunteerable.with_phone }
  scope :schedulers, -> { coordinators.or(social_workers) }
  scope :with_phone, -> { where.not(phone: nil) }
  scope :verified, -> { where(verified: true) }
  scope :announceable, -> { with_phone.verified }

  scope :speaks_language, lambda { |language|
    where(first_language: language).or(where(second_language: language))
  }

  before_save :check_phone_verification

  def self.menu
    where(nil).map { |u| [u.to_s, u.id] }.sort_by(&:first)
  end

  def self.total_volunteers_by_spoken_language(current_user, start_at, end_at)
    filter_by_office_users(current_user, true)
      .joins('INNER JOIN languages ON languages.id IN '\
               '(users.first_language_id, users.second_language_id)')
      .joins(:needs)
      .then { |scope| filter_by_date_range(scope, start_at, end_at) }
      .group('languages.name')
      .count
  end

  def self.total_volunteer_hours_by_user(current_user, start_at, end_at)
    filter_by_office_users(current_user, false)
      .joins(shifts: :need)
      .then { |scope| filter_by_date_range(scope, start_at, end_at) }
      .group('users.id')
      .sum('shifts.duration / 60.0')
  end

  def self.exclude_blockouts(start_at, end_at)
    sql = <<~SQL
      LEFT OUTER JOIN blockouts
      ON blockouts.user_id = users.id
      AND tsrange(start_at, end_at) &&
            tsrange('#{start_at.to_s(:db)}', '#{end_at.to_s(:db)}')
    SQL

    joins(sql)
      .where(blockouts: { id: nil })
  end

  def active_for_authentication?
    super && !deactivated
  end

  def at_least_one_office
    return if offices.any?

    errors.add(:base, 'At least one office assignment is required')
  end

  def at_least_one_age_range
    return if age_ranges.any?

    errors.add(:base, 'At least one age range selection is required')
  end

  ROLES.each do |role|
    define_method "#{role}?" do
      self.role.eql?(role)
    end
  end

  def name
    "#{first_name} #{last_name}".presence || email
  end

  alias to_s name

  def notifiable?
    volunteerable? && phone.present?
  end

  def scheduler?
    role.in? [COORDINATOR, SOCIAL_WORKER, ADMIN]
  end

  def volunteerable?
    role.in? [COORDINATOR, VOLUNTEER]
  end

  def role_display
    I18n.t("user.roles.#{role}", default: ->(*_args) { role.titleize })
  end

  # standard E.164 format used by Twilio
  def e164_phone
    '+1' + phone.gsub(/\D/, '')
  end

  def office_notification_ids
    office_users.notifiable.pluck(:office_id)
  end

  def office_notification_ids=(ids)
    ids = ids.reject(&:blank?).map(&:to_i)
    office_users.each do |ou|
      ou.update!(send_notifications: ou.office_id.in?(ids))
    end
  end

  private

  def require_volunteer_profile_attributes?
    (volunteer? || coordinator?) && invitation_accepted_at?
  end

  def check_phone_verification
    return unless phone_changed? && phone_was.present?

    self.verified = false
  end

  def self.parse_start_date(date)
    (date ? Date.parse(date) : DateTime.new(2000, 1, 1)).beginning_of_day
  end

  def self.parse_end_date(date)
    (date ? Date.parse(date) : DateTime.yesterday).end_of_day
  end

  def self.filter_by_date_range(scope, start_at, end_at)
    scope.where('needs.start_at between ? AND ?', parse_start_date(start_at), parse_end_date(end_at))
  end

  def self.filter_by_office_users(current_user, use_volunteerable_scope)
    if current_user.admin?
      use_volunteerable_scope ? volunteerable : all
    elsif current_user.coordinator?
      (use_volunteerable_scope ? volunteerable : User).where(id: current_user.offices.map(&:users).flatten.map(&:id))
    else
      raise "#{current_user} does not have the proper permissions"
    end
  end
end
