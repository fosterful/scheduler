require 'rails_helper'

RSpec.describe OptoutsController, type: :controller do
  describe 'POST create' do
    it 'returns 302' do
      post :create
      expect(response.status).to eq(302)
    end
  end
end
