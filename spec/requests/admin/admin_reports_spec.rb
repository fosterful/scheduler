# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin reports spec', type: :request do
  context 'with unauthorized access' do
    before { sign_in create(:user) }

    it 'does not allow unauthorized access' do
      get admin_reports_path

      expect(response).to redirect_to(:root)
    end
  end

  context 'with authorized access' do
    before { sign_in create :user, role: 'admin' }

    describe '#index' do
      it 'returns a 200 response' do
        get admin_reports_path

        expect(response).to be_successful
      end
    end

    describe '#total_volunteer_minutes_by_office' do
      it 'returns total volunteer minutes grouped by office' do
        get admin_reports_total_volunteer_minutes_by_office_path(:csv)

        expect(response.body).to include('Office ID', 'Volunteer Minutes')
      end
    end

    describe '#total_volunteer_minutes_by_state' do
      it 'returns total volunteer minutes grouped by state' do
        get admin_reports_total_volunteer_minutes_by_state_path(:csv)

        expect(response.body).to include('State', 'Volunteer Minutes')
      end
    end

    describe '#total_volunteer_minutes_by_county' do
      it 'returns total volunteer minutes grouped by county' do
        get admin_reports_total_volunteer_minutes_by_county_path(:csv),
            params: { state: 'WA' }

        expect(response.body).to include('County', 'Volunteer Minutes')
      end
    end

    describe '#total_children_served_by_office' do
      it 'returns total children served grouped by office' do
        get admin_reports_total_children_served_by_office_path(:csv)

        expect(response.body).to include('Office ID', 'Children Served')
      end
    end

    describe '#total_children_served_by_state' do
      it 'returns total children served grouped by state' do
        get admin_reports_total_children_served_by_state_path(:csv)

        expect(response.body).to include('State', 'Children Served')
      end
    end

    describe '#total_children_served_by_county' do
      it 'returns total children served grouped by county' do
        get admin_reports_total_children_served_by_county_path(:csv),
            params: { state: 'WA' }

        expect(response.body).to include('County', 'Children Served')
      end
    end

    describe '#total_children_by_demographic' do
      it 'returns total children grouped by demographic' do
        get admin_reports_total_children_by_demographic_path(:csv)

        expect(response.body).to include('Preferred Language', 'Number of Children')
      end
    end

    describe '#total_volunteers_by_race' do
      it 'returns total volunteers grouped by race' do
        get admin_reports_total_volunteers_by_race_path(:csv)

        expect(response.body).to include('Race', 'Number of Volunteers')
      end
    end

    describe '#total_volunteer_minutes_by_user' do
      it 'returns total volunteer minutes grouped by user' do
        get admin_reports_total_volunteer_minutes_by_user_path(:csv)

        expect(response.body).to include('User ID', 'Total Volunteer Minutes')
      end
    end

    describe '#total_volunteers_by_spoken_language' do
      it 'returns total volunteers grouped by spoken language' do
        get admin_reports_total_volunteers_by_spoken_language_path(:csv)

        expect(response.body).to include('Language', 'Total Volunteer Minutes')
      end
    end
  end
end
