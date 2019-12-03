# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RemindWorker do
  let(:need) { create(:need) }
  let(:need2) { create(:need) }

  describe '#perform' do
    subject { -> { described_class.new.perform } }

    it { is_expected.not_to change(SendTextMessageWorker.jobs, :size) }

    context 'when there are available shifts' do
      before {
        create(:shift, need: need, start_at: 1.hour.from_now,
          created_at: 2.hours.ago)
        create(:shift, need: need2, start_at: 1.hour.from_now,
          created_at: 2.hours.ago)
      }

      it { is_expected.not_to change(SendTextMessageWorker.jobs, :size) }

      context 'when there are users pending response' do
        let(:volunteer) { create(:user) }
        before { need.update!(notified_user_ids: [volunteer.id]) }
        before { need2.update!(notified_user_ids: [volunteer.id]) }

        it { is_expected.to change(SendTextMessageWorker.jobs, :size).by(2) }
      end
    end
  end
end
