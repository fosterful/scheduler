require 'rails_helper'

RSpec.describe "Admin users spec", type: :request do
  before { sign_in create :user }

  it 'does not allow unauthorized access' do
    get admin_users_path
    expect(response).to redirect_to(:root)
  end

  describe "#create" do
    before { sign_in create :user, role: 'admin' }

    it "redirects to show view after creating the user" do
      post admin_users_path, params: { user: { email: 'foo@example.com', role: 'volunteer' } }
      expect(response).to redirect_to(admin_user_path(User.last))
    end

    it 'renders errors if present' do
      post admin_users_path, params: { user: { role: 'volunteer' } }
      expect(response.body).to include('error')
    end
  end
end
