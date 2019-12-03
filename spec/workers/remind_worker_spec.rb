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
end
