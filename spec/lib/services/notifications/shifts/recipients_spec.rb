# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Shifts::Recipients do
  describe '#call' do
    let(:object) { described_class.call(shift, action, event_data) }
    let(:shift) { create(:shift) }
    let(:need) { shift.need }
    let(:volunteer) { create(:user, offices: [need.office]) }
    let(:event_data) { { current_user: volunteer } }
    let(:scheduler) { create(:social_worker, offices: [need.office]) }
    let(:coordinator) { create(:coordinator, offices: [need.office]) }
    let!(:office_staff) { [scheduler, coordinator] }

    context 'when create' do
      let(:action) { :create }

      it 'calls appropriate class' do
        expect(Services::Notifications::Shifts::Recipients::Create)
          .to receive(:initialize).with(shift, event_data)

        object
      end
    end

    context 'when update' do
      let(:action) { :update }
      let(:event_data) { { current_user: volunteer } }

      it 'returns expected users' do
        social_workers
        need.update!(user: volunteer)
        shift.user = volunteer

        result = object

        expect(result).to eql([coordinator, volunteer])
      end

      it 'returns coordinator if need user is not volunteer' do
        shift.user = volunteer

        result = object

        expect(result).to eql([])
      end
    end

    context 'when destroy' do
      let(:action) { :destroy }

      it 'calls appropriate class' do
        expect(Services::Notifications::Shifts::Recipients::Destroy)
          .to receive(:initialize).with(shift, event_data)

        object
      end
    end
  end

end
