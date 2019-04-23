# frozen_string_literal: true

module NotificationConcern
  # Please note that this concern expects the following variables to be defined
  # and accessible in the including module/class:
  # age_range_ids, preferred_language

  def scope_users_by_language(users)
    return users if preferred_language.blank?

    users.speaks_language(preferred_language)
  end

  def scope_users_by_age_ranges(users)
    return users unless age_range_ids.any?

    users.joins(:age_ranges).where(age_ranges: { id: age_range_ids })
  end

end
