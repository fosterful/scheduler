class OmdRrule
  def initialize(*args)
    self.rule = RRule::Rule.new(*args)
  end

  def last_recurrence
    rule.between(Time.zone.now, 3.years.from_now).last
  end

  def current_recurrence_times
    rule.between(Time.zone.now, 15.days.from_now)
  end

  private
  attr_accessor :rule
end