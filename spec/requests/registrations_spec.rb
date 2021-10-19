require 'rails_helper'

RSpec.describe 'User registrations', type: :request do
  let(:user) { create :user, covid_19_vaccinated: nil }

  before { sign_in user }

  describe '#update' do
    context 'when updating only the users covid_19_vaccinated' do
      it 'allows update without password' do
        expect { put user_registration_path, params: { user: { covid_19_vaccinated: true } }}.to change {
          user.reload.covid_19_vaccinated
        }.from(nil).to(true)
      end
    end
  end
end