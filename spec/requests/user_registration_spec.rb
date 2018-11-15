require "rails_helper"

RSpec.describe "User registration", :type => :request do
  describe '#create' do
    it 'redirect to new user session path after signup' do
      post user_registration_path, params: { user: { email: 'foo@example.com', password: 'foobar', password_confirmation: 'foobar', role: 'volunteer' } }
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end