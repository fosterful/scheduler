# frozen_string_literal: true

module StartAtHelper
  # this module expects a DateTime field, start_at, to be defined

  def starting_day
    return 'Today' if start_at.today?

    start_at.to_s(:month_day)
  end

  def start_time
    start_at.to_s(:time)
  end

end
