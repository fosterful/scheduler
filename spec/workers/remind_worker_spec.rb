# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RemindWorker do
  let(:need) { create(:need) }
  let(:need2) { create(:need) }
  let(:need3) { create(:need) }
  let(:need4) { create(:need) }
  let(:volunteer) { create(:user) }

  describe '#perform' do
    subject { -> { described_class.new.perform } }

    it { is_expected.not_to change(SendTextMessageWorker.jobs, :size) }

    context 'when there are available shifts' do
      let(:user_with_shift) { create(:user) }
      before {
        create(:shift, need: need, start_at: 1.hour.from_now,
          created_at: 2.hours.ago)
        create(:shift, need: need2, start_at: 1.hour.from_now,
          created_at: 2.hours.ago)
        create(:shift, need: need3, start_at: 1.hour.from_now,
          created_at: 2.hours.ago, user: user_with_shift)
        create(:shift, need: need4, start_at: 1.hour.from_now,
          created_at: Time.now)
      }

      it { is_expected.not_to change(SendTextMessageWorker.jobs, :size) }

      context 'when there are users pending response' do
        before {
          need.update!(notified_user_ids: [volunteer.id])
          need2.update!(notified_user_ids: [volunteer.id])
          need3.update!(notified_user_ids: [volunteer.id])
          need4.update!(notified_user_ids: [volunteer.id])
        }

        it { is_expected.to change(SendTextMessageWorker.jobs, :size).by(2) }
      end
    end

    context 'when a need starts on a future day' do
      let(:ct) { Time.current }
      let(:time) {
        Time.new(ct.year, ct.month, ct.day, hour, 0, 0, ct.formatted_offset)
      }
      before {
        Timecop.freeze(time)
        need = create(:need, start_at: 1.day.from_now, created_at: 1.day.ago)
        create(:shift, need: need, start_at: 1.day.from_now,
          created_at: 1.day.ago)
        need.update!(notified_user_ids: [volunteer.id])
      }
      after { Timecop.return }

      context 'when it is noon' do
        let(:hour) { 12 }

        it { is_expected.to change(SendTextMessageWorker.jobs, :size).by(1) }
      end

      context 'when it is not noon' do
        let(:hour) { 13 }

        it { is_expected.not_to change(SendTextMessageWorker.jobs, :size) }
      end
    end
  end
end
