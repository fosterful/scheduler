# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Shifts::Destroy do
  subject { described_class.call(shift, 'https://test.com') }

  let(:user) { create(:user) }
  let(:url) { 'https://test.com' }
  let(:message) do
    "A shift has been removed from a need at your local office. #{url}"
  end

  describe '#call' do
    context 'a user is assigned to the shift' do
      let(:shift) { create(:shift, user: user) }

      it 'notifies the user' do
        expect(SendTextMessageWorker)
          .to receive(:perform_async).with(user.phone, message)

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

end
