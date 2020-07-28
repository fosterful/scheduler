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
  
        expect(response).to redirect_to :root
      end
    end
  end
end
