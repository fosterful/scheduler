# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Needs do

  let(:user) { create(:user) }
  let(:office) { user.offices.first! }
  let(:need) { create(:need_with_shifts, user: user, office: office) }
  let(:object) { described_class.new(need, action, args) }
  let(:action) { :destroy }
  let(:shift) { need.shifts.first! }
  let(:phone) { '(555) 555-5555' }
  let!(:shift_user) do
    u          = create(:user, phone: phone)
    shift.user = u
    shift.save!
    u
  end
  let(:args) { nil }
  let(:destroy_msg) { 'A need at Vancouver Office has been deleted.' }

  describe '#notify' do
    it 'enqueues messages' do
      expect(Services::TextMessageEnqueue).to receive(:send_messages)
                                                .once
                                                .with([phone], destroy_msg)

      object.notify
    end
  end

  describe '#phone_numbers' do
    it 'phone_numbers' do
      needs = described_class.new(need, :destroy)

      result = needs.phone_numbers

      expect(result).to eql([phone])
    end
  end

end
