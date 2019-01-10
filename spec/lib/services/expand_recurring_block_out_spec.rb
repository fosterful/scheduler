require 'rails_helper'

RSpec.describe Services::ExpandRecurringBlockOut do
  subject { described_class.call(block_out) }

  describe '#call' do
    context 'with a new BlockOut' do
      let(:block_out) do
        build :block_out,
              start_at: 1.day.from_now,
              end_at: 2.days.from_now,
              rrule: 'FREQ=DAILY;COUNT=3;INTERVAL=1;WKST=MO'
      end

      it 'saves the blockout' do
        expect { subject }.to change { block_out.persisted? }.from(false).to(true)
      end

      it 'expands the occurrences' do
        expect { subject }.to change { BlockOut.occurrences.count }.by(3)
      end
    end

    context 'with an existing blockout' do
      let(:block_out) do
        create :block_out_with_occurrences, max_occurrence_count: 3
      end

      it 'does not change the number of occurrences' do
        expect { subject }.not_to(change { block_out.occurrences.count })
      end

      it 're-creates the occurrences' do
        expect { subject }.to(change { block_out.reload.occurrence_ids })
      end

      context 'with new dates excluded' do
        it 'removes the newly excluded occurrences' do
          block_out.update(exdate: [block_out.reload.occurrences.first.start_at])
          expect { subject }.to change { BlockOut.occurrences.count }.by(-1)
        end
      end
    end
  end
end