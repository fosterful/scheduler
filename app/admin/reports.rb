# frozen_string_literal: true

ActiveAdmin.register_page 'Reports' do
  content do
    render partial: 'index'
  end

  controller do
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

    def content_disposition(report_name)
      "attachment; filename=\"#{DateTime.current.to_i}-#{report_name}.csv\""
    end
  end

  page_action :total_volunteer_hours_by_office, method: :get do
    @headers = ['Office ID', 'Volunteer Hours']
    @data    = Office.total_volunteer_hours_by_office
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = content_disposition(HOURS_BY_OFFICE)
        headers['Content-Type']        = 'text/csv'
      end
      format.json { render json: @data.to_json }
    end
  end

  page_action :total_children_served_by_office, method: :get do
    @headers = ['Office ID', 'Children Served']
    @data    = Office.total_children_served_by_office
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = content_disposition(CHILDREN_BY_OFFICE)
        headers['Content-Type']        = 'text/csv'
      end
      format.json { render json: @data.to_json }
    end
  end

  page_action :total_volunteer_hours_by_state, method: :get do
    @headers = ['State', 'Volunteer Hours']
    @data    = Office.total_volunteer_hours_by_state
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = content_disposition(HOURS_BY_STATE)
        headers['Content-Type']        = 'text/csv'
      end
      format.json { render json: @data.to_json }
    end
  end

  page_action :total_children_served_by_state, method: :get do
    @headers = ['State', 'Children Served']
    @data    = Office.total_children_served_by_state
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = content_disposition(CHILDREN_BY_STATE)
        headers['Content-Type']        = 'text/csv'
      end
      format.json { render json: @data.to_json }
    end
  end

  page_action :total_volunteer_hours_by_county, method: :get do
    @headers = ['County', 'Volunteer Hours']
    @data    = Office.total_volunteer_hours_by_county(params['state'])
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = content_disposition(HOURS_BY_COUNTY)
        headers['Content-Type']        = 'text/csv'
      end
      format.json { render json: @data.to_json }
    end
  end

  page_action :total_children_served_by_county, method: :get do
    @headers = ['County', 'Children Served']
    @data    = Office.total_children_served_by_county(params['state'])
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = content_disposition(CHILDREN_BY_COUNTY)
        headers['Content-Type']        = 'text/csv'
      end
      format.json { render json: @data.to_json }
    end
  end

  page_action :total_volunteer_hours_by_user, method: :get do
    @headers = ['User ID', 'Total Volunteer Hours']
    @data    = User.total_volunteer_hours_by_user
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = content_disposition(HOURS_BY_USER)
        headers['Content-Type']        = 'text/csv'
      end
      format.json { render json: @data.to_json }
    end
  end

  page_action :total_children_by_demographic, method: :get do
    @headers = ['Preferred Language', 'Number of Children']
    @data    = Office.total_children_by_demographic
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = content_disposition(CHILDREN_BY_DEMO)
        headers['Content-Type']        = 'text/csv'
      end
      format.json { render json: @data.to_json }
    end
  end

  page_action :total_volunteers_by_race, method: :get do
    @headers = ['Race', 'Number of Volunteers']
    @data    = Office.total_volunteers_by_race
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = content_disposition(VOLUNTEERS_BY_RACE)
        headers['Content-Type']        = 'text/csv'
      end
      format.json { render json: @data.to_json }
    end
  end

  page_action :total_volunteers_by_spoken_language, method: :get do
    @headers = ['Language', 'Total Volunteer Hours']
    @data    = User.total_volunteers_by_spoken_language
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = content_disposition(VOLUNTEERS_BY_LANGUAGE)
        headers['Content-Type']        = 'text/csv'
      end
      format.json { render json: @data.to_json }
    end
  end

  menu priority: 6
end
