require "rails_helper"

RSpec.describe "User registration", :type => :request do
  describe '#create' do
    it 'redirect to new user session path after signup' do
      post user_registration_path, params: { user: { email: 'foo@example.com', password: 'foobar', password_confirmation: 'foobar', role: 'volunteer' } }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe '#new' do
    it 'redirect to new user session if role is not defined' do
      get new_user_registration_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirect to new user session if role is not valid' do
      get new_user_registration_path, params: { user: { role: 'admin' } }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'renders when role is valid' do
      get new_user_registration_path, params: { user: { role: 'volunteer' } }
      expect(response).to have_http_status(:ok)
    end
  end
end