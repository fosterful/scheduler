require 'rails_helper'

RSpec.describe ExpandRecurringBlockOut do
  let(:block_out) { build :block_out }

  subject { described_class.call(block_out) }

  describe '#call' do
    let(:block_out) do
      build :block_out,
            start_at: 1.day.from_now,
            end_at: 2.days.from_now,
            rrule: 'FREQ=WEEKLY;COUNT=3;INTERVAL=1;WKST=MO'
    end

    it 'expands the recurrences' do
      expect { subject }.to change { BlockOut.recurrences.count }.by(3)
    end
  end
end