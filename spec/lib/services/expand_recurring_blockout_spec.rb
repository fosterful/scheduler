# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::ExpandRecurringBlockout do
  subject { described_class.call(blockout) }

  describe '#call' do
    context 'with a new Blockout' do
      let(:blockout) do
        build :blockout,
              start_at: 1.day.from_now,
              end_at:   2.days.from_now,
              rrule:    'FREQ=DAILY;COUNT=3;INTERVAL=1;WKST=MO'
      end

      it 'saves the blockout' do
        expect { subject }.to change(blockout, :persisted?).from(false).to(true)
      end

      it 'expands the occurrences' do
        expect { subject }.to change { Blockout.occurrences.count }.by(3)
      end
    end

    context 'with an existing blockout' do
      let(:blockout) do
        create :blockout_with_occurrences, max_occurrence_count: 3
      end

      it 'does not change the number of occurrences' do
        expect { subject }.not_to(change { blockout.occurrences.count })
      end

      it 're-creates the occurrences' do
        expect { subject }.to(change { blockout.reload.occurrence_ids })
      end

      context 'with new dates excluded' do
        it 'removes the newly excluded occurrences' do
          blockout.update(exdate: [blockout.reload.occurrences.first.start_at])
          expect { subject }.to change { Blockout.occurrences.count }.by(-1)
        end
      end
    end
  end
end
