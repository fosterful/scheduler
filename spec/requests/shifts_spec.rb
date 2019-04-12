# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Shifts', type: :request do

  let(:office) { create :office }
  let(:user) { create :user, role: 'coordinator', offices: [office] }
  let(:volunteer) { create :user, role: 'volunteer', offices: [office] }
  let(:need) { create :need_with_shifts, user: user, office: office }
  let!(:shift) { need.shifts.first }

  describe '#index' do
    before { sign_in user }

    it 'renders the index view' do
      get need_shifts_path(need)

      expect(response).to render_template(:index)
    end
  end

  describe '#create' do
    before { sign_in user }

    context 'success' do
      it 'is redirects to the need' do
        expect(Services::Notifications::Shifts::Create)
          .to receive(:call).and_return(true)

        post need_shifts_path(need), params: { shift: attributes_for(:shift) }

        expect(response).to redirect_to(need_shifts_path(need))
      end
    end

    context 'failure' do
      it 'renders the new view' do
        expect_any_instance_of(Shift).to receive(:save).and_return(false)

        post need_shifts_path(need), params: { shift: attributes_for(:shift) }

        expect(flash[:alert]).to eql('Whoops! something went wrong.')
      end
    end
  end

  describe '#update' do
    before { sign_in volunteer }

    it 'redirects to the associated need' do
      expect(Services::Notifications::Shifts::Update)
        .to receive(:call).and_return(true)

      put need_shift_path(need, shift),
          params: { shift: { user_id: volunteer.id } }

      expect(response).to redirect_to(need_path(need))
    end

    context 'success' do
      it 'sets the flash to display the successful change message' do
        expect(Services::Notifications::Shifts::Update)
          .to receive(:call).and_return(true)

        put need_shift_path(need, shift),
            params: { shift: { user_id: volunteer.id } }

        expect(flash[:notice]).to eql('Shift Claimed!')
      end
    end

    context 'failure' do
      it 'sets the flash to display an error message' do
        expect_any_instance_of(Shift).to receive(:save).and_return(false)

        put need_shift_path(need, shift),
            params: { shift: { user_id: volunteer.id } }

        expect(flash[:alert]).to eql('Whoops! something went wrong.')
      end
    end
  end

  describe '#destroy' do
    before { sign_in user }

    it 'redirects to shift index' do
      delete need_shift_path(need, shift)

      expect(response).to redirect_to(need_shifts_path(need))
    end

    context 'success' do
      it 'sets the flash to display the successful change message' do
        expect(Services::Notifications::Shifts::Destroy)
          .to receive(:call).and_return(true)

        delete need_shift_path(need, shift)

        expect(flash[:notice]).to eql('Shift Successfully Destroyed')
      end
    end

    context 'failure' do
      it 'sets the flash to display an error message' do
        expect_any_instance_of(Shift).to receive(:destroy).and_return(false)

        delete need_shift_path(need, shift)

        expect(flash[:alert]).to eql('Whoops! something went wrong.')
      end
    end
  end
end
