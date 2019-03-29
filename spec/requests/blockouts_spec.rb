# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Blockouts', type: :request do
  let(:user) { create :user }
  let(:blockout) { create :blockout, user: user }

  before { sign_in user }

  describe '#create' do
    context 'with unauthorized params' do
      it 'is unauthorized' do
        allow_any_instance_of(BlockoutsController).to receive(:authorize).and_raise(Pundit::NotAuthorizedError)
        post blockouts_path, as: :json, params: { blockout: { foo: 'bar' } }
        expect(response).to be_unauthorized
      end
    end

    context 'with valid params' do
      it 'is successful and returns the blockout' do
        post blockouts_path, as: :json, params: { blockout: attributes_for(:blockout) }
        expect(response).to be_successful
        expect(JSON.parse(response.body).keys).to include('id', 'user_id', 'rrule')
      end
    end

    context 'with invalid params' do
      it 'is unprocessable' do
        post blockouts_path, as: :json, params: { blockout: { foo: 'bar' } }
        expect(response).to be_unprocessable
      end
    end
  end

  describe '#update' do
    context 'with valid params' do
      let(:time) { Time.zone.now }

      it 'is successful and returns the blockout' do
        put blockout_path(blockout), as: :json, params: { blockout: { exdate: [time] } }
        expect(response).to be_successful
        expect(response.body).to include(time.to_json)
      end
    end

    context 'with invalid params' do
      it 'is unprocessable' do
        put blockout_path(blockout), as: :json, params: { blockout: { start_at: 1.day.ago } }
        expect(response).to be_unprocessable
      end
    end
  end

  describe '#destroy' do
    it 'destroys the blockout' do
      delete blockout_path(blockout), as: :json
      expect(response).to be_successful
      expect { blockout.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
