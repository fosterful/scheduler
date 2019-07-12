# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Shifts::Recipients do
  describe '#call' do
    let(:object) { described_class.new(shift, action, event_data) }
    let(:shift) { create(:shift) }
    let(:office) { shift.need.office }
    let(:volunteer) { create(:user, offices: [office]) }
    let(:event_data) { { current_user: volunteer } }
    let(:scheduler) { office.users.social_workers.first }
    let(:coordinator) { create(:coordinator, offices: [office]) }
    let!(:office_staff) { [scheduler, coordinator] }

    context 'when create' do
      let(:action) { :create }

      it 'returns expected users' do
        coordinator.update(age_range_ids: shift.need.age_range_ids)
        shift.need.update!(user: scheduler)

        result = object.recipients

        expect(result).to eql([coordinator])
      end
    end

    context 'when update' do
      let(:action) { :update }
      let(:event_data) { { current_user: volunteer } }

      it 'returns expected users' do
        shift.need.update!(user: volunteer)
        shift.user = volunteer

        result = object.recipients

        expect(result).to eql([scheduler, volunteer])
      end
    end

    context 'when destroy' do
      let(:action) { :destroy }

      it 'returns shift user if present' do
        shift.update!(user: volunteer)

        result = object.recipients

        expect(result).to eql([volunteer])
      end

      it 'returns empty collection if no shift user' do
        result = object.recipients

        expect(result).to eql([])
      end
    end
  end

end
