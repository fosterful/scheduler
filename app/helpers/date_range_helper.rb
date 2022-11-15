module DateRangeHelper

  # MOVE THIS TO app/lib/includers?
  def select_dates
    # explicitly pass in date or rely on rails params?
    params[:start_date] = Time.now.beginning_of_month.to_date.to_s if params[:start_date].blank?
    params[:end_date] = Time.now.end_of_month.to_date.to_s if params[:end_date].blank?
    @start_date, @end_date = params[:start_date], params[:end_date]
    # returns an array with the @start/@end dates

    # In this code, the default start/end is 30 day
    # In the DateRangeFinderHelper the default start/end is from 01,01,2000 to yesterday
    # What behavior is preffered?
  end

  # Is this function needed, Why? because removing the dates just defaults the
  # time range to start of 2000?
  def clear_dates; end

end
