# frozen_string_literal: true

module Services
  class ExpandRecurringBlockout
    include Procto.call
    include Concord.new(:blockout)
    include Adamantium::Flat

    def call
      return blockout.save if blockout.rrule.blank?
      return false unless save_blockout

      blockout.occurrences.delete_all
      Services::BulkInserter::Insert.call(occurrences) if occurrences.any?
      true
    end

    private

    def save_blockout
      # last_occurrence defaults to three years
      # from the current date. So, we only set it on
      # creation, or if the rrule includes an end date (UNTIL)
      if !blockout.persisted? || blockout.rrule.include?('UNTIL')
        blockout.last_occurrence = rrule.last_occurrence
      end
      blockout.save
    end

    def rrule
      OmdRrule.new(blockout.rrule,
                   dtstart: blockout.start_at,
                   exdate:  blockout.exdate,
                   tzid:    blockout.user.time_zone)
    end

    def occurrences
      rrule.current_occurrence_times.map do |rt|
        Blockout.new shared_attributes.merge(
          parent_id: blockout.id,
          start_at:  rt,
          end_at:    rt.advance(seconds: blockout.duration_in_seconds)
        )
      end
    end
    memoize(:occurrences)

    def shared_attributes
      attrs = blockout.attributes.symbolize_keys
      attrs.slice(:user_id,
                  :created_at,
                  :updated_at)
    end
  end
end
