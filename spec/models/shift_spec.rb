# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shift, type: :model do
  let(:shift) { build :shift }

  it 'has a valid factory' do
    expect(shift.valid?).to be(true)
  end

  describe '#notify_user_of_cancelation' do
    it 'notifies the user when the shift is deleted' do
      shift = create :shift, start_at: Time.zone.parse('2019-01-09 09:00:00 -0800')
      expect { shift.destroy }
        .to have_enqueued_job(SendTextMessageJob)
        .with('0123456789', 'Your shift on 01/09/2019 at 9:00AM has been canceled.')
    end
  end
end
