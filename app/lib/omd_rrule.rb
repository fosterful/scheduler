class OmdRrule
  def initialize(*args)
    self.rule = RRule::Rule.new(*args)
  end

  def last_occurrence
    rule.between(Time.zone.now.beginning_of_day, 3.years.from_now.end_of_day).last
  end

  def current_occurrence_times
    rule.between(Time.zone.now.beginning_of_day, 15.days.from_now.end_of_day)
  end

  private
  attr_accessor :rule
end