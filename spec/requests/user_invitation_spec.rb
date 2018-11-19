require "rails_helper"

RSpec.describe "User invitations", :type => :request do
  before { sign_in create :user }

  describe '#create' do
    it 'renders a 200 response after the invitation is sent' do
      post user_invitation_path, params: { user: { email: 'foo@example.com', role: 'volunteer' } }
      expect(response).to redirect_to(:root)
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