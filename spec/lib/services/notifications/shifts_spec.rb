# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Shifts do
  let(:user) { create(:user) }
  let(:office) { user.offices.first! }
  let(:need) { create(:need_with_shifts, user: user, office: office) }
  let(:object) do
    described_class.new(shift,
                        action,
                        current_user: current_user, user_was: user_was)
  end
  let(:current_user) { nil }
  let(:user_was) { nil }
  let(:action) { :destroy }
  let(:shift) { need.shifts.first! }
  let(:phone) { '(360) 555-0110' }
  let!(:shift_user) do
    u          = create(:user, phone: phone, age_ranges: need.age_ranges)
    shift.user = u
    shift.save!
    u
  end
  let(:starts) { shift.start_at.strftime(format) }
  let(:ends) { shift.end_at.strftime(format) }
  let(:args) { nil }
  let(:format) { '%I:%M%P' }
  let(:destroy_msg) do
    "The shift from #{starts} to #{ends} has been removed from a need at your local office. http://localhost:3000/needs"
  end

  describe '#notify' do
    it 'enqueues messages' do
      expect(Services::TextMessageEnqueue).to receive(:send_messages)
                                                .once
                                                .with([phone], destroy_msg)
                                                .and_call_original

      object.notify
    end

    it 'yields if block supplied' do
      expect do
        object.notify { puts 'hello' }
      end.to output("hello\n").to_stdout
    end

    describe 'notified_user_ids' do
      it 'adds to notified_user_ids' do
        expect(need.notified_user_ids).to be_empty
        need.office.users << shift_user
        expect(need.users_to_notify).to eq([shift_user, need.user])
        object.notify
        expect(need.notified_user_ids).to eq([shift_user.id])
      end

      it 'does not remove from notified_user_ids' do
        need.update notified_user_ids: [shift_user.id]
        expect(need.users_to_notify).to eq([need.user])
        object.notify
        expect(need.notified_user_ids).to eq([shift_user.id])
      end
    end
  end

  describe '#phone_numbers' do
    it 'phone_numbers' do
      shifts = described_class.new(shift, :destroy)

      result = shifts.phone_numbers

      expect(result).to eql([phone])
    end
  end

end
