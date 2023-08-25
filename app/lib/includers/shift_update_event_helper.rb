# frozen_string_literal: true

module ShiftUpdateEventHelper
  # This module relies on the following variables being declared and present:
  # current_user, need, user, user_was
  NOTIFIABLE_ROLES = [User::ADMIN, User::COORDINATOR, User::SOCIAL_WORKER].freeze

  def shift_user_is_current_user?
    user.present? && user.eql?(current_user)
  end

  def current_user_left_shift?
    user.nil? && current_user.eql?(user_was)
  end

  def scheduler_with_user?
    current_user.scheduler? && user.present?
  end

  def scheduler_without_user?
    current_user.scheduler? && user.nil?
  end

  def notifiable_office_users_and_need_user
    notifiable_office_users | [need.user]
  end

  def notifiable_office_users
    users_with_notifiable_role = User.where('role IN (?)', NOTIFIABLE_ROLES)
    need.office
        .users
        .merge(User.notifiable(users_with_notifiable_role))
        .where(office_users: { send_notifications: true })
        .to_a
  end
end
