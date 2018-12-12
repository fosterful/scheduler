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
      office = create :office
      post admin_users_path, params: { user: { email: 'foo@example.com', role: 'volunteer', office_ids: [office.id] } }
      expect(response).to redirect_to(admin_user_path(User.last))
    end

    it 'renders errors if present' do
      post admin_users_path, params: { user: { role: 'volunteer' } }
      expect(response.body).to include('error')
    end
  end

  describe 'show' do
    let(:user) { create :user, role: 'admin' }
    before { sign_in user }

    it 'has a 200 response' do
      get admin_user_path(user)
      expect(response).to be_success
    end

    it 'displays the users email' do
      get admin_user_path(user)
      expect(response.body).to include(user.email)
    end
  end
end
