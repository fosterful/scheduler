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
      it 'requires last_recurrence if rrule is present' do
        block_out.rrule = 'abc123'
        expect(block_out.valid?).to be(false)
        expect(block_out.errors.full_messages).to include("Last recurrence can't be blank")
      end
    end
  end
end
