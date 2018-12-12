require "rails_helper"

RSpec.describe "User invitations", type: :request do
  let(:user) { create :user, role: 'coordinator' }
  before { sign_in user }

  describe '#create' do
    it 'renders a 200 response after the invitation is sent' do
      office = create :office
      user.offices << office
      post user_invitation_path, params: { user: { email: 'foo@example.com', role: 'volunteer', office_ids: [office.id] } }
      expect(response).to redirect_to(:root)
    end

    it 'does not allow user to invite user to office they are not assigned to' do
      office = create :office
      post user_invitation_path, params: { user: { email: 'foo@example.com', role: 'volunteer', office_ids: [office.id] } }
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end
  end

  describe '#new' do
    it 'redirect to new user session if role is not defined' do
      get new_user_invitation_path
      expect(response).to redirect_to(root_path)
    end

    it 'redirect to new user session if role is not valid' do
      get new_user_invitation_path, params: { user: { role: 'admin' } }
      expect(response).to redirect_to(root_path)
    end

    it 'renders when role is valid' do
      get new_user_invitation_path, params: { user: { role: 'volunteer' } }
      expect(response).to have_http_status(:ok)
    end
  end
end