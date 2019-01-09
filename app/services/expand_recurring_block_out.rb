class ExpandRecurringBlockOut
  include Procto.call
  include Concord.new(:block_out)
  include Adamantium::Flat

  def call
    return false unless block_out.persisted? || block_out.save
    block_out.recurrences.delete_all
    bulk_insert_recurrences if recurrences.any?
  end

  private

  def rrule
    RRule::Rule.new(block_out.rrule,
                    dtstart: block_out.start_at,
                    exdate: block_out.exdate)
  end

  def recurrence_times
    rrule.between(Time.now, 15.days.from_now)
  end

  def recurrences
    recurrence_times.map do |rt|
      shared_attributes.merge(
        parent_id: block_out.id,
        start_at: rt,
        end_at: rt.advance(seconds: block_out.duration_in_seconds)
      )
    end
  end

  def shared_attributes
    attrs = block_out.attributes.symbolize_keys
    attrs.slice(:user_id,
                :created_at,
                :updated_at)
  end

  # TODO: Turn me into my own service class
  def bulk_insert_recurrences
    keys = recurrences.first.keys.join(', ')
    values = recurrences.map { |h| "(#{h.values.map { |v| "'#{v}'" }.join(',')})" }.join(',')
    ActiveRecord::Base.connection.execute("INSERT INTO block_outs (#{keys}) VALUES #{values}")
  end
end
