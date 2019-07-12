# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Shifts::Recipients do
  describe '#recipients' do
    let(:object) { described_class.new(shift, action, event_data) }
    let(:shift) { create(:shift) }
    let(:office) { shift.need.office }
    let(:volunteer) { create(:user, offices: [office]) }
    let(:event_data) { { current_user: volunteer } }

    context 'on create' do
      let(:action) { :create }
      let(:klass) { Services::Notifications::Shifts::Recipients::Create }

      it 'correctly routes create event' do
        expect(klass).to receive(:new).and_call_original

        object.recipients
      end
    end

    context 'on update' do
      let(:action) { :update }
      let(:klass) { Services::Notifications::Shifts::Recipients::Update }

      it 'correctly routes update event' do
        expect(klass).to receive(:new).and_call_original

        object.recipients
      end
    end

    context 'on destroy' do
      let(:action) { :destroy }
      let(:klass) { Services::Notifications::Shifts::Recipients::Destroy }

      it 'correctly routes destroy event' do
        expect(klass).to receive(:new).and_call_original

        object.recipients
      end
    end
  end

end
