# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Blockout, type: :model do
  let(:blockout) { build :blockout }

  it 'has a valid factory' do
    expect(blockout.valid?).to be(true)
  end

  describe 'validations' do
    it 'requires start_at be present' do
      blockout = build :blockout, start_at: nil
      expect(blockout.valid?).to be(false)
    end

    it 'requires start_at be in the future' do
      blockout = build :blockout, start_at: 1.day.ago
      expect(blockout.valid?).to be(false)
      expect(blockout.errors.full_messages)
        .to include('Start at must be in the future')
    end

    it 'allows a start_at of today' do
      blockout = build :blockout, start_at: Time.zone.now
      expect(blockout.valid?).to be(true)
    end

    it 'requires end_at be present' do
      blockout = build :blockout, end_at: nil
      expect(blockout.valid?).to be(false)
    end

    it 'requires end_at be in the future if present' do
      blockout = build :blockout, end_at: 1.day.ago
      expect(blockout.valid?).to be(false)
      expect(blockout.errors.full_messages)
        .to include('End at must be beyond start at')
    end

    context 'with rrule' do
      it 'requires last_occurrence if rrule is present' do
        blockout.rrule = 'abc123'
        expect(blockout.valid?).to be(false)
        expect(blockout.errors.full_messages)
          .to include("Last occurrence can't be blank")
      end
    end
  end

  describe '.current' do
    it 'returns the current block outs based on start_at and last_occurrence' do
      b1     = create(:blockout,
                      start_at:        1.day.from_now,
                      end_at:          1.day.from_now.advance(hours: 1),
                      last_occurrence: 1.week.from_now)
      b2     = create(:blockout,
                      start_at:        20.days.from_now,
                      end_at:          20.days.from_now.advance(hours: 1),
                      last_occurrence: 2.months.from_now)
      b3     = build(:blockout,
                     start_at:        1.week.ago,
                     end_at:          1.week.ago.advance(hours: 1),
                     last_occurrence: 1.day.ago).save(validate: false)

      result = Blockout.current

      expect(result).to include(b1)
      expect(result).not_to include(b2, b3)
    end
  end

  describe '.recurring' do
    it 'returns recurring block outs based on rrule presence' do
      b1     = create :blockout_with_occurrences
      b2     = create :blockout

      result = Blockout.recurring

      expect(result).to include(b1)
      expect(result).not_to include(b2)
    end
  end

  describe '.current_recurring' do
    it 'merges .recurring & .current' do
      b1     = create(:blockout_with_occurrences)
      b2     = build(:blockout_with_occurrences,
                     start_at:        1.week.ago,
                     end_at:          1.week.ago.advance(hours: 1),
                     last_occurrence: 1.day.ago).save(validate: false)
      b3     = create(:blockout,
                      start_at:        1.day.from_now,
                      end_at:          1.day.from_now.advance(hours: 1),
                      last_occurrence: 1.week.from_now)

      result = Blockout.recurring

      expect(result).to include(b1)
      expect(result).not_to include(b2, b3)
    end
  end

  describe '.occurrences' do # scope test
    it 'supports named scope occurrences' do
      expect(described_class.limit(3).occurrences).to all(be_a(described_class))
    end
  end

  describe '.excluding_occurrences' do # scope test
    it 'supports named scope excluding_occurrences' do
      expect(described_class.limit(3).excluding_occurrences)
        .to all(be_a(described_class))
    end
  end

  describe '#duration_in_seconds' do
    it 'duration_in_seconds' do
      result = blockout.duration_in_seconds

      expect(result.round).to be(3600)
    end
  end

end
