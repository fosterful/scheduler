# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::ShiftNotifications::Destroy do
  subject { described_class.call(shift, 'https://test.com') }

  let(:user) { create(:user) }

  context 'a user is assigned to the shift' do
    let(:shift) { create(:shift, user: user) }

    it 'notifies the user' do
      expect(SendTextMessageWorker).to receive(:perform_async).with(user.phone, 'A shift has been removed from a need at your local office. https://test.com')
      subject
    end
  end

  context 'a user is not assigned to the shift' do
    let(:shift) { create(:shift) }

    it 'does not notify anyone' do
      expect(subject.blank?).to be true
    end
  end
end
