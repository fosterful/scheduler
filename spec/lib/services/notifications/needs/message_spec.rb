# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Needs::Message do
  describe '#message' do
    let(:object) { described_class.new(need, action) }
    let(:need) { create(:need, start_at: starts) }
    let(:starts) { Time.zone.now.tomorrow.change(hour: 12, minute: 0) }

    context 'on create' do
      let(:action) { :create }
      let(:klass) { Services::Notifications::Needs::Message::Create }

      it 'correctly routes create event' do
        expect(klass).to receive(:new).and_call_original

        object.message
      end
    end

    context 'on destroy' do
      let(:action) { :destroy }
      let(:klass) { Services::Notifications::Needs::Message::Destroy }

      it 'correctly routes destroy event' do
        expect(klass).to receive(:new).and_call_original

        object.message
      end
    end
  end

end
