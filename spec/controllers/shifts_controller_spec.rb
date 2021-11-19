# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShiftsController, type: :controller do
  let(:user) { need.user }
  let(:other_user) { create(:user) }
  let(:need) { create(:need_with_shifts) }
  let!(:shift) { need.shifts.first! }

  before { sign_in user }

  describe '#index' do
    it 'GET index' do
      get :index, params: { need_id: need.id.to_param }

      expect(response).to have_http_status(:ok)
    end
  end

  describe '#create' do
    it 'POST create' do
      expect do
        post :create, params: { need_id: need.id,
                                shift:   { need_id:  need.id.to_param,
                                           duration: 120.to_param,
                                           user_id:  user.id.to_param,
                                           start_at: Time.zone.now.advance(weeks: 1).to_param } }
      end.to change(Shift, :count).by(1)

      expect(response).to have_http_status(:found)
    end
  end

  describe '#update' do
    it 'PATCH update claims shift' do
      patch :update, params: { need_id: need.id,
                               id:      shift.id,
                               shift:   { user_id: other_user.id.to_param } }

      expect(response).to have_http_status(:found)
      expect(shift.reload.user_id).to equal(other_user.id)
    end
    
    it 'PATCH update releases shift' do
      patch :update, params: { need_id: need.id,
      id:      shift.id,
      shift:   { user_id: other_user.id.to_param } }
      patch :update, params: { need_id: need.id,
      id:      shift.id,
      shift:   { user_id: nil }
    }
    
    expect(flash[:notice]).to eq 'Shift Released!'
    expect(shift.reload.user_id).to equal(nil)
    end

  end

  describe '#destroy' do
    it 'DELETE destroy' do
      delete :destroy, params: { need_id: need.id, id: shift.id }

      expect(response).to have_http_status(:found)
      expect { shift.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
