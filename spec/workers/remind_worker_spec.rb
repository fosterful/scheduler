# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RemindWorker do
  let(:need) { create(:need) }

  describe '.perform_async' do
    subject { -> { described_class.perform_async(1.hour.from_now, need.id) } }

    it { is_expected.to change(described_class.jobs, :size).by(1) }
  end

  describe '#perform' do
    subject { -> { described_class.new.perform(need.id) } }

    it { is_expected.not_to change(SendTextMessageWorker.jobs, :size) }
    it { is_expected.not_to change(described_class.jobs, :size) }

    context 'when there are available shifts' do
      before { create(:shift, need: need, start_at: 1.hour.from_now) }

      it { is_expected.not_to change(SendTextMessageWorker.jobs, :size) }
      it { is_expected.to change(described_class.jobs, :size).by(1) }

      context 'when there are users pending response' do
        let(:volunteer) { create(:user) }
        before { need.update!(notified_user_ids: [volunteer.id]) }

        it { is_expected.to change(SendTextMessageWorker.jobs, :size).by(1) }
        it { is_expected.to change(described_class.jobs, :size).by(1) }
      end
    end
  end

  describe '.next_queue_time' do
    subject {
      Timecop.freeze(time) { described_class.next_queue_time }
    }

    context 'when current time is before 9am' do
      let(:time) { Time.current.beginning_of_day + 7.hours }
      it { is_expected.to eq(Date.current.beginning_of_day + 9.hours) }
    end

    context 'when current time is after 8pm' do
      let(:time) { Time.current.beginning_of_day + 21.hours }
      it { is_expected.to eq(Date.current.tomorrow.beginning_of_day + 9.hours) }
    end

    context 'when current time is between 9am and 8pm' do
      let(:time) { Time.current.beginning_of_day + 14.hours }
      it { is_expected.to eq(time + 1.hour) }
    end
  end
end
