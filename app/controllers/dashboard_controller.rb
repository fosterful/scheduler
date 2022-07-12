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
    redirect_to :root unless coordinator_or_admin?

    @data =
      if current_user.admin?
        fetch_office_users_data(Office.all)
      else
        fetch_office_users_data(current_user.offices)
      end
  end

  def query
    redirect_to :root unless coordinator_or_admin?

    if params[:office_id].present?
      @office = Office.find(params[:office_id])
    end

    if params[:start_date].blank?
      params[:start_date] = Time.now.beginning_of_month.to_date.to_s
    end

    @start_date = params[:start_date]

    if params[:end_date].blank?
      params[:end_date] = Time.now.end_of_month.to_date.to_s
    end

    @end_date = params[:end_date]

    needs_analysis_by_date_and_office
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

  def coordinator_or_admin?
    DashboardPolicy.new(current_user).users?
  end

  def needs_analysis_by_date_and_office
    dashboard_queries = Services::DashboardQueries.new(
      params[:office_id],
      params[:start_date],
      params[:end_date]
    )

    @user_list_by_hours_volunteered = dashboard_queries.users_by_hours_volunteered
    @user_list_by_need_created = dashboard_queries.users_by_needs_created
    @hours_volunteered = dashboard_queries.hours_volunteered
    @needs_created_count = dashboard_queries.needs_created
    @shifts_created_count = dashboard_queries.shifts_created
    @shifts_claimed_count = dashboard_queries.shifts_claimed
    @shifts_unclaimed_count = dashboard_queries.shifts_unclaimed
  end
end
