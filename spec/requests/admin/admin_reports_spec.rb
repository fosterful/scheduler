# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin reports spec', type: :request do
  context 'unauthorized access' do
    before { sign_in create(:user) }

    it 'does not allow unauthorized access' do
      get admin_reports_path
      expect(response).to redirect_to(:root)
    end
  end

  context 'authorized access' do
    before { sign_in create :user, role: 'admin' }

    describe '#index' do
      it 'returns a 200 response' do
        get admin_reports_path
        expect(response).to be_successful
      end
    end

    describe '#total_volunteer_minutes_by_office' do
      it 'does a thing' do
        get admin_reports_total_volunteer_minutes_by_office_path
        expect(response.body).to include('office_id,volunteer_minutes')
      end
    end

    describe '#total_volunteer_minutes_by_state' do
      it 'does something' do
        get admin_reports_total_volunteer_minutes_by_state_path
        expect(response.body).to include('state,volunteer_minutes')
      end
    end

    describe '#total_volunteer_minutes_by_county' do
      it 'does something' do
        get admin_reports_total_volunteer_minutes_by_county_path
        expect(response.body).to include('county,volunteer_minutes')
      end
    end

    describe '#total_children_served_by_office' do
      it 'does something' do
        get admin_reports_total_children_served_by_office_path
        expect(response.body).to include('office_id,children_served')
      end
    end

    describe '#total_children_served_by_state' do
      it 'does something' do
        get admin_reports_total_children_served_by_state_path
        expect(response.body).to include('state,children_served')
      end
    end

    describe '#total_children_served_by_county' do
      it 'does something' do
        get admin_reports_total_children_served_by_county_path
        expect(response.body).to include('county,children_served')
      end
    end

    describe '#total_children_by_demographic' do
      it 'does something' do
        get admin_reports_total_children_by_demographic_path
        expect(response.body).to include('preferred_language,number_of_children')
      end
    end

    describe '#total_volunteers_by_race' do
      it 'does something' do
        get admin_reports_total_volunteers_by_race_path
        expect(response.body).to include('race,number_of_volunteers')
      end
    end

    describe '#total_volunteer_minutes_by_user' do
      it 'does something' do
        get admin_reports_total_volunteer_minutes_by_user_path
        expect(response.body).to include('user_id,total_volunteer_minutes')
      end
    end

    describe '#total_volunteers_by_spoken_language' do
      it 'does something' do
        get admin_reports_total_volunteers_by_spoken_language_path
        expect(response.body).to include('language,total_volunteer_minutes')
      end
    end
  end
end
