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

  def dashboard
    # This should redirect to root if not admin or coordinator
    redirect_to :root unless DashboardPolicy.new(current_user).users?

    active_by_hours
    active_by_needs
    shift_data
  end

  def active_by_hours
    # hours are by claimed shifts
    @users_active_by_shift_claimed = User
    .joins(shifts: :need) # nested association
    .where(needs: {office_id: params[:office_id]})
    .then { |scope| filter_by_date_range(scope, params[:start_date], params[:end_date]) }
    .group(:id, :role, :first_name, :last_name, :email)
    .sum('shifts.duration / 60.0')

    # format SQL query to easily access data
    # https://api.rubyonrails.org/v7.0.3/classes/ActiveRecord/QueryMethods.html#method-i-where
    # try name placeholders
    @users_active_by_shift_claimed = @users_active_by_shift_claimed.map do | key, value |
      { id: key[0], role: key[1], name: "#{key[2]} #{key[3]}", email: key[4], hours: value }
    end

    # sort by decending values
    @users_active_by_shift_claimed = @users_active_by_shift_claimed.sort_by! { |user| user[:hours]}.reverse

    # create nested array where is inner array is users grouped by role, then sort inner role by hours
  end

  def active_by_needs
    @users_active_by_need_created = User
    .joins(:needs)
    .where(needs: {office_id: params[:office_id]})
    .then { |scope| filter_by_date_range(scope, params[:start_date], params[:end_date]) }
    .group(:id, :role, :first_name, :last_name, :email)
    .count

    @users_active_by_need_created = @users_active_by_need_created.map do | key, value |
      { id: key[0], role: key[1], name: "#{key[2]} #{key[3]}", email: key[4], needs_created: value }
    end

    #  # sort by decending values
    @users_active_by_need_created = @users_active_by_need_created.sort_by! { |user| user[:needs_created]}.reverse
  end

  def shift_data

    # DATA OK

    # count of all needs created including unclaimed shifts, cant see unclaimed shift
    @total_needs_created = Need
    .where(office_id: params[:office_id])
    .then { |scope| filter_by_date_range(scope, params[:start_date], params[:end_date]) }
    .count

    # how do we ge need join shift?
    # @test = Need
    # .joins(:shifts)
    # .where(office_id: params[:office_id])
    # .then { |scope| filter_by_date_range(scope, params[:start_date], params[:end_date]) }
    # list of need for every shift created that has associated need

    #count of all shifts created including unclaimed shifts
    @total_shifts_created = Shift
    .joins(:need)
    .where(needs: {office_id: params[:office_id]})
    .then { |scope| filter_by_date_range(scope, params[:start_date], params[:end_date]) }
    .count

    #count of all shifts claimed
    @total_shifts_claimed = Shift
    .joins(:need)
    .where(needs: {office_id: params[:office_id]})
    .where.not(user_id: nil)
    .then { |scope| filter_by_date_range(scope, params[:start_date], params[:end_date]) }
    .count

    @total_shifts_unclaimed = (@total_shifts_created - @total_shifts_claimed)



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
