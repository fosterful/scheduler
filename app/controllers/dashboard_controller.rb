# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :authorize_user

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

  SAFE_MODELS = ['Office', 'User']

  def reports; end

  def download_report
    return redirect_to dashboard_download_report_path unless sensitive_params_are_safe

    @headers = params[:headers]
    @data    = if params[:state]
      params[:model].constantize.send(params[:data_method], current_user, params[:state], params[:start_date], params[:end_date])
    else
      params[:model].constantize.send(params[:data_method], current_user, params[:start_date], params[:end_date])
    end

    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = content_disposition(params[:filename])
        headers['Content-Type']        = 'text/csv'
        render 'report_template.csv'
      end
    end
  end

  private

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

  def authorize_user
    redirect_to :root unless DashboardPolicy.new(current_user).dashboard?
  end

  def content_disposition(report_name)
    "attachment; filename=\"#{DateTime.current.to_i}-#{report_name}.csv\""
  end
end
