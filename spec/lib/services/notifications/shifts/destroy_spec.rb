# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Shifts::Destroy do
  subject { described_class.call(shift) }

  let(:user) { create(:user) }
  let(:url) { 'https://test.com' }
  let(:message) do
    "A shift has been removed from a need at your local office. #{url}"
  end

  describe '#call' do
    context 'a user is assigned to the shift' do
      let(:shift) { create(:shift, user: user) }
      let(:start_at_string) { shift.start_at.strftime('%I:%M%P') }
      let(:end_at_string) { shift.end_at.strftime('%I:%M%P') }
      let(:message_string) do
        "The shift from #{start_at_string} to #{end_at_string} has been "\
          "removed from a need at your local office. https://test.com"
      end

      it 'notifies the user' do
        expect(SendTextMessageWorker)
          .to receive(:perform_async).with(user.phone, message_string)

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
