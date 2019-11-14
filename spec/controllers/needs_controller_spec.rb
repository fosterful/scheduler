# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NeedsController, type: :controller do
  let(:user) { need.user }
  let(:need) { create(:need_with_shifts) }
  let(:another_need) do
    create(:need_with_shifts, start_at: 1.day.from_now, user: user, office: need.office)
  end

  before { sign_in user }

  describe '#index' do
    it 'GET index' do
      another_need

      get :index

      expect(response).to have_http_status(:ok)
      expect(assigns(:needs).to_a).to eql([need, another_need])
    end
  end

  describe '#show' do
    render_views

    it 'returns ok and sets expected variables' do
      get :show, params: { id: need.id }

      expect(response).to have_http_status(:ok)
      expect(flash[:alert]).to be nil
      expect(assigns(:optout)).to be_a_new(Optout)
      assert_select ".new_optout input[type=submit]" +
        "[value='I am not available for this request.']"
    end

    context 'when optout already exists' do
      let!(:optout) { create(:optout, need: need, user: user) }

      context 'when optout is active' do
        it 'shows user is unavailable' do
          get :show, params: { id: need.id }
          assert_select '.optout-container p',
            'You have marked yourself as unavailable for this need.'
        end
      end

      context 'when optout is not active' do
        before { create(:shift, need: need, start_at: need.start_at + 2.hours) }

        it 'allows them to opt out again' do
          get :show, params: { id: need.id }
          assert_select ".edit_optout input[type=submit]" +
            "[value='I am not available for this request.']"
        end
      end
    end
  end

  describe '#create' do
    it 'POST create' do
      expect do
        post :create, params: { need: { number_of_children: 2,
                                        expected_duration:  2,
                                        start_at:           Time.zone.now.advance(weeks: 1).to_param,
                                        office_id:          need.office_id.to_param,
                                        age_range_ids:      [AgeRange.first!.id],
                                        preferred_language_id: 1 } }
      end.to change(Need, :count).by(1)

      expect(response).to have_http_status(:found)
    end
  end

  describe '#edit' do
    it 'GET edit' do
      get :edit, params: { id: need.id }

      expect(response).to have_http_status(:ok)
    end
  end

  describe '#update' do
    it 'PATCH update' do
      patch :update, params: { id: need.id, need: { number_of_children: 2 } }

      expect(response).to have_http_status(:found)
      expect(need.reload.number_of_children).to equal(2)
    end
  end

  describe '#destroy' do
    it 'DELETE destroy' do
      delete :destroy, params: { id: need.id }

      expect(response).to have_http_status(:found)
      expect { need.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
