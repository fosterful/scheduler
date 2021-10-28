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

    context 'when updating other fields' do
      it 'requires the password' do
        expect { put user_registration_path, params: { user: { first_name: 'Bobby' } }}.not_to change {
          user.reload.email
        }

        expect { put user_registration_path, params: { user: { current_password: 'foobar', first_name: 'Bobby' } }}.to change {
          user.reload.first_name
        }
      end
    end
  end
  
  describe '#vaccination_status' do
    
    it 'redirects to root if not logged in' do
      sign_out user
      expect(get vaccination_status_path).to redirect_to(root_path)
    end
    
    it 'does not redirect to root if logged in' do
      sign_in user
      expect(get vaccination_status_path).not_to redirect_to(root_path)
    end
  end
end