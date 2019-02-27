module Services
  module NotificationConcern
    def scope_users_by_language(users)
      return users unless preferred_language.present?

      users.speaks_language(preferred_language)
    end

    def scope_users_by_age_ranges(users)
      return users unless age_range_ids.any?

      users.joins(:age_ranges).where(age_ranges: { id: age_range_ids })
    end
  end
end