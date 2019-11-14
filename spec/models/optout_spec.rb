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

  it 'should update start_at and end_at' do
    shift = create(:shift, need: need, start_at: need.start_at + 2.hours)
    optout.save
    shift.reload # avoid mysterious nanosecond incongruity
    expect(optout.end_at).to eq(shift.end_at)
  end

  it 'should increment occurrences on update' do
    expect(optout.occurrences).to eq(1)
    optout.save
    expect(optout.occurrences).to eq(2)
  end

  describe '#active?' do
    it 'returns whether the optout is still within the range' do
      expect(optout.active?).to eq(true)
      shift = create(:shift, need: need, start_at: need.start_at + 2.hours)
      expect(optout.active?).to eq(false)
      optout.save
      expect(optout.active?).to eq(true)
    end
  end
end
