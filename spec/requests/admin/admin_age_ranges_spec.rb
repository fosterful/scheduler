require 'rails_helper'

RSpec.describe "Admin age_ranges spec", type: :request do
  before { sign_in create :user }

  it 'does not allow unauthorized access' do
    get admin_age_ranges_path
    expect(response).to redirect_to(:root)
  end

  describe "#create" do
    before { sign_in create :user, role: 'admin' }

    it "redirects to show view after creating the office" do
      post admin_age_ranges_path, params: { age_range: { min: 1, max: 1 } }
      expect(response).to redirect_to(admin_age_range_path(AgeRange.last))
    end

    it 'renders errors if present' do
      post admin_age_ranges_path, params: { age_range: { min: 1 } }
      expect(response.body).to include('error')
    end
  end

  describe 'show' do
    before { sign_in create :user, role: 'admin' }
    let(:age_range) { create :age_range }

    it 'displays the age_range' do
      get admin_age_range_path(age_range)
      expect(response.body).to include('1 to 1')
    end
  end
end
