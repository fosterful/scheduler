# frozen_string_literal: true

module Services
  class DashboardQueries
    include DateRangeFilterHelper
    include Concord.new(:office_id, :start_date, :end_date)
    include Adamantium::Flat

    def users_by_hours_volunteered
      list_users = find_users_by_hours.map do |key, value|
        { id:    key.fetch(0),
          role:  key.fetch(1),
          name:  "#{key.fetch(2)} #{key.fetch(3)}",
          email: key.fetch(4),
          hours: value }
      end

      list_users.sort_by! { |user| user[:hours] }.reverse
    end

    def hours_volunteered
      find_users_by_hours.sum { |_key, value| value }
    end

    def users_by_needs_created
      list_users = find_users_by_needs.map do |key, value|
        { id:            key.fetch(0),
          role:          key.fetch(1),
          name:          "#{key.fetch(2)} #{key.fetch(3)}",
          email:         key.fetch(4),
          needs_created: value }
      end

      list_users.sort_by! { |user| user[:needs_created] }.reverse
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
      .where(needs: { office_id: office_id })
      .then { |scope| filter_by_date_range(scope, start_date, end_date) }
      .count
    end

    def shifts_claimed
      Shift
      .joins(:need)
      .where(needs: { office_id: office_id })
      .where.not(user_id: nil)
      .then { |scope| filter_by_date_range(scope, start_date, end_date) }
      .count
    end

    def shifts_unclaimed
      shifts_created - shifts_claimed
    end

    private

    def find_users_by_hours
      User
      .joins(shifts: :need)
      .where(needs: { office_id: office_id })
      .then { |scope| filter_by_date_range(scope, start_date, end_date) }
      .group(:id, :role, :first_name, :last_name, :email)
      .sum('shifts.duration / 60.0')
    end

    def find_users_by_needs
      User
      .joins(:needs)
      .where(needs: { office_id: office_id })
      .then { |scope| filter_by_date_range(scope, start_date, end_date) }
      .group(:id, :role, :first_name, :last_name, :email)
      .count
    end
  end
end
