# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboard', type: :request do
  describe '#reports' do
    context 'as an admin' do
      let(:user) { create :user, role: 'admin' }
      before { sign_in user }

      it 'is successful' do
        get dashboard_reports_path
  
        expect(response).to be_successful
      end
    end

    context 'as a coordinator' do
      let(:user) { create :user, role: 'coordinator' }
      before { sign_in user }

      it 'is successful' do
        get dashboard_reports_path
  
        expect(response).to be_successful
      end
    end

    context 'as a volunteer' do
      let(:user) { create :user, role: 'volunteer' }
      before { sign_in user }

      it 'is successful' do
        get dashboard_reports_path
  
        expect(response).to redirect_to :root
      end
    end

    context 'as a social worker' do
      let(:user) { create :user, role: 'social_worker' }
      before { sign_in user }

      it 'is successful' do
        get dashboard_reports_path
  
        expect(response).to be_successful
      end
    end
  end

  describe '#users' do
    context 'as an admin' do
      let(:user) { create :user, role: 'admin' }
      before { sign_in user }

      it 'is successful' do
        get dashboard_users_path
  
        expect(response).to be_successful
      end
    end

    context 'as a coordinator' do
      let(:user) { create :user, role: 'coordinator' }
      before { sign_in user }

      it 'is successful' do
        get dashboard_users_path
  
        expect(response).to be_successful
      end
    end

    context 'as a volunteer' do
      let(:user) { create :user, role: 'volunteer' }
      before { sign_in user }

      it 'is successful' do
        get dashboard_users_path
  
        expect(response).to redirect_to :root
      end
    end

    context 'as a social worker' do
      let(:user) { create :user, role: 'social_worker' }
      before { sign_in user }

      it 'is successful' do
        get dashboard_users_path
  
        expect(response).to redirect_to :root
      end
    end
  end

  describe '#download_report' do
    let(:user) { create :user, role: 'admin' }
    before { sign_in user }

    it 'does nothing when given wrong params' do
      get dashboard_download_report_path, params: { state: 'WA', headers: ['County', 'Children Served'], data_method: 'foobar', filename: DashboardController::CHILDREN_BY_COUNTY, model: 'Foobar', format: :csv }

      expect(response).to redirect_to :dashboard_download_report
    end

    context 'with state param' do
      it 'is successful' do
        get dashboard_download_report_path, params: { state: 'WA', headers: ['County', 'Children Served'], data_method: DashboardController::CHILDREN_BY_COUNTY.underscore, filename: DashboardController::CHILDREN_BY_COUNTY, model: 'Office', format: :csv }

        expect(response).to be_successful
      end
    end

    context 'without state param' do
      it 'is successful' do
        get dashboard_download_report_path, params: { headers: ['Office Name', 'Volunteer Hours'], data_method: DashboardController::HOURS_BY_OFFICE.underscore, filename: DashboardController::HOURS_BY_OFFICE, model: 'Office', format: :csv }

        expect(response).to be_successful
      end
    end

    context 'when data method has a matching template' do
      it 'renders the matching template' do
        create(:shift, user: user, need: build(:need, start_at: 1.day.ago))
        get dashboard_download_report_path, params: { headers: ['id', 'First Name', 'Last Name', 'Total Volunteer Hours'], data_method: DashboardController::HOURS_BY_USER.underscore, filename: DashboardController::HOURS_BY_USER, model: 'User', format: :csv }

        expect(response.body).to include("#{user.id},#{user.first_name},#{user.last_name},1.0")
      end
    end

    context 'with state and date range' do
      it 'is successful' do
        get dashboard_download_report_path, params: { start_date: 'Jan 1, 2010', end_date: 'Jan 1, 2020', state: 'OR', headers: ['County', 'Volunteer Hours'], data_method: DashboardController::HOURS_BY_COUNTY.underscore, filename: DashboardController::HOURS_BY_COUNTY, model: 'Office', format: :csv }

        expect(response).to be_successful
      end
    end

    context 'without state and with date range' do
      it 'is successful' do
        get dashboard_download_report_path, params: { start_date: 'Jan 1, 2010', end_date: 'Jan 1, 2020', headers: ['State', 'Volunteer Hours'], data_method: DashboardController::HOURS_BY_STATE.underscore, filename: DashboardController::HOURS_BY_STATE, model: 'Office', format: :csv }

        expect(response).to be_successful
      end
    end
  end
end
