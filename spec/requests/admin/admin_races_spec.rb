# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin races spec', type: :request do
  before { sign_in create :user }

  it 'does not allow unauthorized access' do
    get admin_races_path
    expect(response).to redirect_to(:root)
  end

  describe '#create' do
    before { sign_in create :user, role: 'admin' }

    it 'redirects to show view after creating the race' do
      post admin_races_path, params: { race: { name: 'foo' } }
      expect(response).to redirect_to(admin_race_path(Race.last))
    end

    it 'renders errors if present (missing name)' do
      post admin_races_path, params: { race: { name: '' } }
      expect(response.body).to include('error')
    end
  end
end
