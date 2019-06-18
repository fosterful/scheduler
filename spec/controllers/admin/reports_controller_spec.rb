# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ReportsController, type: :controller do

  describe '#index' do
    it 'GET index' do
      get :index

      expect(response).to have_http_status(:found)
    end
  end

  describe '#total_volunteer_minutes_by_office' do
    it 'GET total_volunteer_minutes_by_office csv' do
      get :total_volunteer_minutes_by_office, format: :csv

      expect(response).to have_http_status(:found)
    end

    it 'GET total_volunteer_minutes_by_office json' do
      get :total_volunteer_minutes_by_office, format: :json

      expect(response).to have_http_status(:found)
    end
  end

  describe '#total_volunteer_minutes_by_state' do
    it 'GET total_volunteer_minutes_by_state csv' do
      get :total_volunteer_minutes_by_state, format: :csv

      expect(response).to have_http_status(:found)
    end

    it 'GET total_volunteer_minutes_by_state json' do
      get :total_volunteer_minutes_by_state, format: :json

      expect(response).to have_http_status(:found)
    end
  end

  describe '#total_volunteer_minutes_by_county' do
    it 'GET total_volunteer_minutes_by_county csv' do
      get :total_volunteer_minutes_by_county, format: :csv

      expect(response).to have_http_status(:found)
    end

    it 'GET total_volunteer_minutes_by_county json' do
      get :total_volunteer_minutes_by_county, format: :json

      expect(response).to have_http_status(:found)
    end
  end

  describe '#total_children_served_by_office' do
    it 'GET total_children_served_by_office csv' do
      get :total_children_served_by_office, format: :csv

      expect(response).to have_http_status(:found)
    end

    it 'GET total_children_served_by_office json' do
      get :total_children_served_by_office, format: :json

      expect(response).to have_http_status(:found)
    end
  end

  describe '#total_children_served_by_state' do
    it 'GET total_children_served_by_state csv' do
      get :total_children_served_by_state, format: :csv

      expect(response).to have_http_status(:found)
    end

    it 'GET total_children_served_by_state json' do
      get :total_children_served_by_state, format: :json

      expect(response).to have_http_status(:found)
    end
  end

  describe '#total_children_served_by_county' do
    it 'GET total_children_served_by_county csv' do
      get :total_children_served_by_county, format: :csv

      expect(response).to have_http_status(:found)
    end

    it 'GET total_children_served_by_county json' do
      get :total_children_served_by_county, format: :json

      expect(response).to have_http_status(:found)
    end
  end

  describe '#total_children_by_demographic' do
    it 'GET total_children_by_demographic csv' do
      get :total_children_by_demographic, format: :csv

      expect(response).to have_http_status(:found)
    end

    it 'GET total_children_by_demographic json' do
      get :total_children_by_demographic, format: :json

      expect(response).to have_http_status(:found)
    end
  end

  describe '#total_volunteers_by_race' do
    it 'GET total_volunteers_by_race csv' do
      get :total_volunteers_by_race, format: :csv

      expect(response).to have_http_status(:found)
    end

    it 'GET total_volunteers_by_race json' do
      get :total_volunteers_by_race, format: :json

      expect(response).to have_http_status(:found)
    end
  end

  describe '#total_volunteer_minutes_by_user' do
    it 'GET total_volunteer_minutes_by_user csv' do
      get :total_volunteer_minutes_by_user, format: :csv

      expect(response).to have_http_status(:found)
    end

    it 'GET total_volunteer_minutes_by_user json' do
      get :total_volunteer_minutes_by_user, format: :json

      expect(response).to have_http_status(:found)
    end
  end

  describe '#total_volunteers_by_spoken_language' do
    it 'GET total_volunteers_by_spoken_language csv' do
      get :total_volunteers_by_spoken_language, format: :csv

      expect(response).to have_http_status(:found)
    end

    it 'GET total_volunteers_by_spoken_language json' do
      get :total_volunteers_by_spoken_language, format: :json

      expect(response).to have_http_status(:found)
    end
  end

end
