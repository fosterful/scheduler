require 'rails_helper'

RSpec.describe BlockOut, type: :model do
  let(:block_out) { build :block_out }

  it 'has a valid factory' do
    expect(block_out.valid?).to be(true)
  end

  describe 'validations' do
    it 'requires start_at be present' do
      block_out = build :block_out, start_at: nil
      expect(block_out.valid?).to be(false)
    end

    it 'requires start_at be in the future' do
      block_out = build :block_out, start_at: 1.day.ago
      expect(block_out.valid?).to be(false)
      expect(block_out.errors.full_messages).to include('Start at must be in the future')
    end

    it 'requires end_at be present' do
      block_out = build :block_out, end_at: nil
      expect(block_out.valid?).to be(false)
    end

    it 'requires end_at be in the future if present' do
      block_out = build :block_out, end_at: 1.day.ago
      expect(block_out.valid?).to be(false)
      expect(block_out.errors.full_messages).to include('End at must be beyond start at')
    end

    context 'with rrule' do
      it 'requires last_occurrence if rrule is present' do
        block_out.rrule = 'abc123'
        expect(block_out.valid?).to be(false)
        expect(block_out.errors.full_messages).to include("Last occurrence can't be blank")
      end
    end
  end

  describe '.current' do
    it 'returns the current block outs based on start_at and last_occurrence' do
      b1 = create :block_out, start_at: 1.day.from_now, end_at: 1.day.from_now + 1.hour, last_occurrence: 1.week.from_now
      b2 = create :block_out, start_at: 20.days.from_now, end_at: 20.days.from_now + 1.hour, last_occurrence: 2.months.from_now
      b3 = build(:block_out, start_at: 1.week.ago, end_at: 1.week.ago + 1.hour, last_occurrence: 1.day.ago).save(validate: false)
      result = BlockOut.current
      expect(result).to include(b1)
      expect(result).not_to include(b2, b3)
    end
  end

  describe '.recurring' do
    it 'returns recurring block outs based on rrule presence' do
      b1 = create :block_out_with_occurrences
      b2 = create :block_out
      result = BlockOut.recurring
      expect(result).to include(b1)
      expect(result).not_to include(b2)
    end
  end

  describe '.current_recurring' do
    it 'merges .recurring & .current' do
      b1 = create :block_out_with_occurrences
      b2 = build(:block_out_with_occurrences, start_at: 1.week.ago, end_at: 1.week.ago + 1.hour, last_occurrence: 1.day.ago).save(validate: false)
      b3 = create :block_out, start_at: 1.day.from_now, end_at: 1.day.from_now + 1.hour, last_occurrence: 1.week.from_now
      result = BlockOut.recurring
      expect(result).to include(b1)
      expect(result).not_to include(b2, b3)
    end
  end
end
