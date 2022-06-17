# frozen_string_literal: true

module Services
  class DashboardQueries
    include DateRangeFilterHelper

    include Concord.new(:office_id, :start_date, :end_date)
    include Adamantium::Flat #freezes objects, read gem

    def active_by_hours
      users_active_by_shift_claimed = User
      .joins(shifts: :need) # nested association
      .where(needs: {office_id: office_id})
      .then { |scope| filter_by_date_range(scope, start_date, end_date) }
      .group(:id, :role, :first_name, :last_name, :email)
      .sum('shifts.duration / 60.0')

      users_active_by_shift_claimed = users_active_by_shift_claimed.map do | key, value |
        { id: key[0], role: key[1], name: "#{key[2]} #{key[3]}", email: key[4], hours: value }
      end

      users_active_by_shift_claimed = users_active_by_shift_claimed.sort_by! { |user| user[:hours]}.reverse
    end




  end
end
