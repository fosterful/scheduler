module DateRangeFilterHelper
  def parse_start_date(date)
    (date ? Date.parse(date) : DateTime.new(2000, 1, 1)).beginning_of_day
  end

  def parse_end_date(date)
    (date ? Date.parse(date) : DateTime.yesterday).end_of_day
  end

  def filter_by_date_range(scope, start_at, end_at)
    scope.where('needs.start_at between ? AND ?', parse_start_date(start_at), parse_end_date(end_at))
  end
end