# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BlockoutsController, type: :controller do
  let(:user) { create(:user) }
  let(:blockout) { create(:blockout, user: user) }

  before { sign_in user }

  describe '#create' do
    it 'POST create' do
      post :create, params: { blockout: { reason: 'A reason' } }, format: :json

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe '#update' do
    it 'PATCH update' do
      patch :update,
            params: { id: blockout.id, blockout: { reason: 'New reason' } },
            format: :json

      expect(response).to have_http_status(:ok)
      expect(blockout.reload.reason).to eql('New reason')
    end
  end

  describe '#destroy' do
    it 'DELETE destroy' do
      delete :destroy, params: { id: blockout.id }, format: :json

      expect(response).to have_http_status(:ok)
      expect { blockout.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
