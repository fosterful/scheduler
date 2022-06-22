# frozen_string_literal: true

module Services
  class DashboardQueries
    include DateRangeFilterHelper
    include Concord.new(:office_id, :start_date, :end_date)
    include Adamantium::Flat #freezes objects

    def active_by_hours
      users_active_by_shift_claimed = User
      .joins(shifts: :need) # nested association
      .where(needs: {office_id: office_id})
      .then { |scope| filter_by_date_range(scope, start_date, end_date) }
      .group(:id, :role, :first_name, :last_name, :email)
      .sum('shifts.duration / 60.0')

      # Should factor this out into another method
      users_active_by_shift_claimed = users_active_by_shift_claimed.map do | key, value |
        { id: key[0], role: key[1], name: "#{key[2]} #{key[3]}", email: key[4], hours: value }
      end

      # Should factor this out into another method
      users_active_by_shift_claimed.sort_by! { |user| user[:hours]}.reverse
    end

    def active_by_needs
      users_active_by_need_created = User
      .joins(:needs)
      .where(needs: {office_id: office_id})
      .then { |scope| filter_by_date_range(scope, start_date, end_date) }
      .group(:id, :role, :first_name, :last_name, :email)
      .count

      users_active_by_need_created = users_active_by_need_created.map do | key, value |
        { id: key[0], role: key[1], name: "#{key[2]} #{key[3]}", email: key[4], needs_created: value }
      end

      #  # sort by decending values
      users_active_by_need_created.sort_by! { |user| user[:needs_created]}.reverse
    end

    def needs_created
      # count of all needs created including unclaimed shifts, cant see unclaimed shift
      total_needs_created = Need
      .where(office_id: office_id)
      .then { |scope| filter_by_date_range(scope, start_date, end_date) }
      .count
    end

    def shifts_created
      #count of all shifts created including unclaimed shifts
      total_shifts_created = Shift
      .joins(:need)
      .where(needs: {office_id: office_id})
      .then { |scope| filter_by_date_range(scope, start_date, end_date) }
      .count
    end

    def shifts_claimed
      #count of all shifts claimed
      total_shifts_claimed = Shift
      .joins(:need)
      .where(needs: {office_id: office_id})
      .where.not(user_id: nil)
      .then { |scope| filter_by_date_range(scope, start_date, end_date) }
      .count
    end

    def shifts_unclaimed
      total_shifts_unclaimed = (shifts_created - shifts_claimed)
    end
  end
end
