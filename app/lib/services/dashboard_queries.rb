# frozen_string_literal: true

module Services
  class DashboardQueries
    include DateRangeFilterHelper
    # How to define this so we keyword arguments?
    include Concord.new(:office_id, :start_date, :end_date)
    include Adamantium::Flat #freezes objects

    def list_user_active_by_hours
      data = find_active_by_hours
      list_users = data.map do | key, value |
        { id: key.fetch(0),
          role: key.fetch(1),
          name: "#{key.fetch(2)} #{key.fetch(3)}",
          email: key.fetch(4),
          needs_created: value
        }
      end

      #  # sort by decending values
      list_users.sort_by! { |user| user[:needs_created]}.reverse
    end

    def hours_volunteered
      find_active_by_hours.map { | key, value | value }.sum
    end

    def find_active_by_hours #ok
      User
      .joins(shifts: :need) # nested association
      .where(needs: {office_id: office_id})
      .then { |scope| filter_by_date_range(scope, start_date, end_date) }
      .group(:id, :role, :first_name, :last_name, :email)
      .sum('shifts.duration / 60.0')
    end

    # this should called when the needs created is clicked
    def active_by_needs
      users_active_by_need_created = User
      .joins(:needs)
      .where(needs: {office_id: office_id})
      .then { |scope| filter_by_date_range(scope, start_date, end_date) }
      .group(:id, :role, :first_name, :last_name, :email)
      .count

      users_active_by_need_created = users_active_by_need_created.map do | key, value |
        { id: key.fetch(0),
          role: key.fetch(1),
          name: "#{key.fetch(2)} #{key.fetch(3)}",
          email: key.fetch(4),
          needs_created: value
        }
      end

      #  # sort by decending values
      users_active_by_need_created.sort_by! { |user| user[:needs_created]}.reverse
    end

    def needs_created
      Need
      .where(office_id: office_id)
      .then { |scope| filter_by_date_range(scope, start_date, end_date) }
      .count
    end

    def shifts_created
      Shift
      .joins(:need)
      .where(needs: {office_id: office_id})
      .then { |scope| filter_by_date_range(scope, start_date, end_date) }
      .count
    end

    def shifts_claimed
      Shift
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
