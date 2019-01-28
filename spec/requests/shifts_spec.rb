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
  end

  describe '#create' do
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
  end

end