# frozen_string_literal: true

class DashboardController < ApplicationController
  include DateRangeFilterHelper

  CHILDREN_BY_COUNTY     = 'total-children-served-by-county'
  CHILDREN_BY_DEMO       = 'total-children-by-demographic'
  CHILDREN_BY_OFFICE     = 'total-children-served-by-office'
  CHILDREN_BY_STATE      = 'total-children-served-by-state'
  HOURS_BY_COUNTY        = 'total-volunteer-hours-by-county'
  HOURS_BY_OFFICE        = 'total-volunteer-hours-by-office'
  HOURS_BY_STATE         = 'total-volunteer-hours-by-state'
  HOURS_BY_USER          = 'total-volunteer-hours-by-user'
  VOLUNTEERS_BY_LANGUAGE = 'total-volunteers-by-spoken-language'
  VOLUNTEERS_BY_RACE     = 'total-volunteers-by-race'
  # RESPONSES_BY_SHIFT     = 'survey-responses-by-shift'

  SAFE_MODELS = %w(Office User ShiftSurvey).freeze

  def users
    # This should redirect to root if user is not an admin or coordinator
    redirect_to :root unless DashboardPolicy.new(current_user).users?

    @data =
      if current_user.admin?
        fetch_office_users_data(Office.all)
      else
        # This triggers if user is coordinator
        fetch_office_users_data(current_user.offices)
      end
  end

  def query
    # This should redirect to root if not admin or coordinator
    redirect_to :root unless DashboardPolicy.new(current_user).users?
    if params[:office_id].present?
      @office = Office.find(params[:office_id])
    end

    dashboard_queries = Services::DashboardQueries.new(
      params[:office_id],
      params[:start_date],
      params[:end_date]
    )

    # This feels wrong in that we are instantiating alot of instance variables
    @users_active_by_shift_claimed = dashboard_queries.active_by_hours
    @users_active_by_need_created  = dashboard_queries.active_by_needs
    @total_needs_created = dashboard_queries.needs_created
    @total_shifts_created = dashboard_queries.shifts_created
    @total_shifts_claimed = dashboard_queries.shifts_claimed
    @total_shifts_unclaimed = dashboard_queries.shifts_unclaimed

    format_date

    # need to handle default behavior if no date is entered and submit is press,
    #error handling
    # if start_date or end_date is nil?

  end

  # helper method?
  def format_date
    if params[:start_date].present? || params[:end_date].present?
      query_dates = [params[:start_date], params[:end_date]].map do |date|
        Date.parse(date).strftime('%a %d %b %Y')
      end
      @start_date, @end_date = query_dates[0], query_dates[1]
    end
  end

  def reports
    redirect_to :root unless DashboardPolicy.new(current_user).reports?
  end

  def download_report
    redirect_to :root unless DashboardPolicy.new(current_user).reports?

    return redirect_to dashboard_download_report_path unless sensitive_params_are_safe

    set_download_report_variables

    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = content_disposition(params[:filename])
        headers['Content-Type']        = 'text/csv'
        dynamic_template_path = "dashboard/#{params[:data_method]}_template"
        if template_exists?(dynamic_template_path)
          render dynamic_template_path, format: :csv
        else
          render 'report_template', format: :csv
        end
      end
    end
  end

  private

  def set_download_report_variables
    @headers = params[:headers]
    @data =
      if params[:state]
        params[:model].constantize.send(
          params[:data_method], current_user, params[:state], params[:start_date],
          params[:end_date]
        )
      else
        params[:model].constantize.send(
          params[:data_method], current_user, params[:start_date], params[:end_date]
        )
      end
  end

  def fetch_office_users_data(offices)
    offices.each_with_object({}) do |office, hash|
      hash[office.name] = office.users
    end
  end

  def sensitive_params_are_safe
    params[:model].in?(SAFE_MODELS) &&
      params[:data_method].in?([
        CHILDREN_BY_COUNTY,
        CHILDREN_BY_DEMO,
        CHILDREN_BY_OFFICE,
        CHILDREN_BY_STATE,
        HOURS_BY_COUNTY,
        HOURS_BY_OFFICE,
        HOURS_BY_STATE,
        HOURS_BY_USER,
        VOLUNTEERS_BY_LANGUAGE,
        VOLUNTEERS_BY_RACE
      ].map(&:underscore))
  end

  def content_disposition(report_name)
    "attachment; filename=\"#{DateTime.current.to_i}-#{report_name}.csv\""
  end
end
