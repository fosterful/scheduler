require 'rails_helper'

RSpec.describe Optout, type: :model do
  let!(:optout) { create(:optout) }
  let(:need) { optout.need }
  let(:user) { optout.user }

  it 'should validate uniqueness of user and need' do
    expect {
      create(:optout, user: user, need: need)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  describe '#active?' do
    it 'returns false if optout is a new record' do
      optout = build(:optout)
      expect(optout.active?).to be false
      optout.save
      expect(optout.active?).to be true
    end

    it 'returns whether the optout is still within the minimum range' do
      expect(optout.active?).to eq(true)
      create(:shift, need: need, start_at: need.start_at - 2.hours)
      expect(optout.active?).to eq(false)
      optout.update_shift_times
      expect(optout.active?).to eq(true)
    end

    it 'returns whether the optout is still within the maximum range' do
      expect(optout.active?).to eq(true)
      create(:shift, need: need, start_at: need.start_at + 2.hours)
      expect(optout.active?).to eq(false)
      optout.update_shift_times
      expect(optout.active?).to eq(true)
    end
  end

  describe '#update_shift_times' do
    it 'should update start_at' do
      shift = create(:shift, need: need, start_at: need.start_at - 2.hours)
      expect(optout.start_at).not_to eq(shift.start_at)
      optout.update_shift_times
      shift.reload # avoid mysterious nanosecond incongruity
      expect(optout.start_at).to eq(shift.start_at)
    end

    it 'should update end_at' do
      shift = create(:shift, need: need, start_at: need.start_at + 2.hours)
      expect(optout.end_at).not_to eq(shift.end_at)
      optout.update_shift_times
      shift.reload # avoid mysterious nanosecond incongruity
      expect(optout.end_at).to eq(shift.end_at)
    end

    it 'should increment occurrences' do
      create(:shift, need: need, start_at: need.start_at + 2.hours)
      expect(optout.occurrences).to eq(1)
      optout.update_shift_times
      expect(optout.occurrences).to eq(2)
    end
  end
end
