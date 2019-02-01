# frozen_string_literal: true

module Services
  module ShiftNotifications
    class Update
      include Procto.call
      include Concord.new(:shift, :message_type, :url)
      include Adamantium::Flat

      delegate :need, :duration, :user, to: :shift

      def call
        who_to_send_to.each do |user|
          SendTextMessageWorker.perform_async(user.phone, [build_message, need_url(need)].join(' '))
        end
      end

      private

      def volunteers_for_shift
        need
          .office
          .users
          .volunteerable
          .available_within(shift.start_at, shift.end_at)
          .then { |users| scope_users_by_language(users) }
          .then { |users| scope_users_by_age_ranges(users) }
      end

      def scope_users_by_language(users)
        return users unless need.preferred_language.present?

        users.speaks_language(preferred_language)
      end

      def scope_users_by_age_ranges(users)
        return users unless need.age_range_ids.any?

        users.joins(:age_ranges).where(age_ranges: { id: need.age_range_ids })
      end

      def who_to_send_to
        if shift.user_id.nil?
          need.office.users.schedulers
        else
          
        end
      end

      def build_update_message
        if shift.user_id.nil?
          'A Volunteer has been removed from a shift.'
        else
          'A Volunteer has been assigned a shift.'
        end
      end

      def build_message
        case message_type
        when :created
          'A new shift has been added to a need at your local office!'
        when :updated
          build_update_messsage
        when :destroyed
          'A shift has been removed from a need at your local office.'
        else
          raise StandardError, 'somethings wrong here'
        end
      end
    end
  end
end
