# frozen_string_literal: true

module ShiftUpdateEventHelper
  # This module relies on the following variables being declared and present:
  # current_user, need, user, user_was

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

  def social_workers_and_need_user
    social_workers | [need.user]
  end

  def social_workers
    need.office.users.social_workers
  end

end
