# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Shifts", type: :request do
  let(:office) { create :office }
  let(:user) { create :user, role: 'admin', offices: [office] }
  let(:volunteer) { create :user, role: 'volunteer', offices: [office] }
  let(:need) { create :need_with_shifts, user: user, office: office }
  let!(:shift) { need.shifts.first }
  before { sign_in volunteer }

  describe '#new' do
    context 'success' do
      it 'renders the view if the user is an admin' do
      end
      it 'renders the view if the user is in the office and a scheduler' do
      end
    end
    context 'failure' do
      it 'redirects to something' do
        get new_need_shift_path(need)
        expect(response).to be nil
      end
    end
  end

  describe '#create' do
    context 'success' do
      it 'is redirects to the need' do
        post need_shifts_path(need), params: { shift: attributes_for(:shift) }
        expect(response).to redirect_to(assigns(:need))
      end
    end

    context 'failure' do
      it 'renders the new view' do
        post need_shifts_path(need), params: { shift: attributes_for(:shift) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe '#update' do
    it 'redirects to the associated need' do
      put need_shift_path(need, shift), params: {}
      expect(response).to redirect_to(need_path(need))
    end
    context 'success' do
      it 'sets the flash to display the successful change message' do
        expect(Services::SendShiftStatusNotifications).to receive(:call).and_return(true)
        put need_shift_path(need, shift), params: { shift: { user_id: volunteer.id } }
        expect(flash[:notice]).to eql('Shift Claimed!')
      end
    end
    context 'failure' do
      it 'sets the flash to display an error message' do
        expect_any_instance_of(Shift).to receive(:save).and_return(false)
        put need_shift_path(need, shift), params: { shift: { user_id: volunteer.id } }
        expect(flash[:alert]).to eql('Whoops! something went wrong.')
      end
    end
  end

  describe '#destroy' do
    context 'success' do
      it 'is redirects to the need' do
        post need_shifts_path(need), params: { shift: attributes_for(:shift) }
        expect(response).to redirect_to(assigns(:need))
      end
    end
    context 'failure' do
      it 'is redirects to the need' do
        post need_shifts_path(need), params: { shift: attributes_for(:shift) }
        expect(response).to redirect_to(assigns(:need))
      end
    end
  end

end