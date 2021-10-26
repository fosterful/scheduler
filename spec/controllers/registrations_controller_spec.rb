require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  let(:user) { create(:user)}

  before do 
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe '#vaccination_status' do

    it 'redirects to root if not logged in' do
      get :vaccination_status
      expect(subject).to redirect_to(root_path)
    end

    it 'does not redirect to root if logged in' do
      sign_in user
      get :vaccination_status
      expect(subject).not_to redirect_to(root_path)
    end
  end

end