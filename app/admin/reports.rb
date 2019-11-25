ActiveAdmin.register_page 'Reports' do
  content do
    render partial: 'index'
  end

  controller do
    CHILDREN_BY_COUNTY     = 'total-children-served-by-county'
    CHILDREN_BY_DEMO       = 'total-children-by-demographic'
    CHILDREN_BY_OFFICE     = 'total-children-served-by-office'
    CHILDREN_BY_STATE      = 'total-children-served-by-state'
    MINUTES_BY_COUNTY      = 'total-volunteer-minutes-by-county'
    MINUTES_BY_OFFICE      = 'total-volunteer-minutes-by-office'
    MINUTES_BY_STATE       = 'total-volunteer-minutes-by-state'
    MINUTES_BY_USER        = 'total-volunteer-minutes-by-user'
    VOLUNTEERS_BY_LANGUAGE = 'total-volunteers-by-spoken-language'
    VOLUNTEERS_BY_RACE     = 'total-volunteers-by-race'

    def content_disposition(report_name)
      "attachment; filename=\"#{DateTime.current.to_i}-#{report_name}.csv\""
    end
  end

  page_action :total_volunteer_minutes_by_office, method: :get do
    @headers = ['Office ID', 'Volunteer Minutes']
    @data    = Office.total_volunteer_minutes_by_office
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = content_disposition(MINUTES_BY_OFFICE)
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

  page_action :total_volunteer_minutes_by_state, method: :get do
    @headers = ['State', 'Volunteer Minutes']
    @data    = Office.total_volunteer_minutes_by_state
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = content_disposition(MINUTES_BY_STATE)
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

  page_action :total_volunteer_minutes_by_county, method: :get do
    @headers = ['County', 'Volunteer Minutes']
    @data    = Office.total_volunteer_minutes_by_county(params['state'])
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = content_disposition(MINUTES_BY_COUNTY)
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

  page_action :total_volunteer_minutes_by_user, method: :get do
    @headers = ['User ID', 'Total Volunteer Minutes']
    @data    = User.total_volunteer_minutes_by_user
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = content_disposition(MINUTES_BY_USER)
        headers['Content-Type']        = 'text/csv'
      end
      format.json { render json: @data.to_json }
    end
  end

end