# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shift, type: :model do
  let(:shift) { build :shift }

  it 'has a valid factory' do
    expect(shift.valid?).to be(true)
  end

  describe '#notify_user_of_cancelation' do
    it 'notifies the user when the shift is deleted' do
      shift = create(:shift, start_at: Time.zone.parse('2019-01-09 09:00:00 -0800'), user: create(:user))
      expect { shift.destroy }
        .to change(SendTextMessageWorker.jobs, :size)
        .by(1)
    end
  end

  describe '#end_at' do
    it 'end_at' do
      result = shift.end_at

      expect(result).to be_within(5.seconds).of(Time.zone.now.advance(hours: 1))
    end
  end

  describe '#expired?' do
    it 'expired?' do
      result = shift.expired?

      expect(result).to be false
    end

    it 'returns true if expired' do
      shift.start_at = Time.zone.now.advance(hours: -3)

      result = shift.expired?

      expect(result).to be true
    end
  end

  describe '#users_to_notify' do
    it 'users_to_notify' do
      result = shift.users_to_notify

      expect(result).not_to be_nil
    end
  end

end
