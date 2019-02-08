# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::ShiftNotifications::Update do
  let(:office) { create(:office) }
  let(:coordinator) { create(:user, role: 'coordinator', offices: [office]) }
  let(:need) { create(:need_with_shifts, user: coordinator, office: office ) }
  let(:shift) { need.shifts.first }
  let(:volunteer) { create(:user, offices: [office]) }
  let!(:social_worker) { create(:user, role: 'social_worker', offices: [office]) }

  context 'when a volunteer' do
    subject { described_class.call(shift, 'https://test.com', volunteer) }

    context 'assigns themself to a shift' do
      it 'notifies the social workers' do
        shift.assign_attributes(user_id: volunteer.id)
        expect(subject).to include(social_worker)
      end

      it 'notifies the need creator' do
        shift.assign_attributes(user_id: volunteer.id)
        expect(subject).to include(coordinator)
      end
    end

    context 'unassigns themself from a shift' do
      before { shift.update(user: volunteer) }
      it 'notifies the social workers' do
        shift.assign_attributes(user_id: nil)
        expect(subject).to include(social_worker)
      end

      it 'notifies the need creator' do
        shift.assign_attributes(user_id: nil)
        expect(subject).to include(coordinator)
      end
    end
  end

  context 'when a scheduler' do
    subject { described_class.call(shift, 'https://test.com', social_worker) }

    context 'assigns a volunteer' do
      it 'notifies the user being assigned' do
        shift.assign_attributes(user_id: volunteer.id)
        expect(subject).to include(volunteer)
      end
    end

    context 'unassigns a volunteer' do
      before { shift.update(user: volunteer) }

      it 'notifies the user being unassigned' do
        shift.assign_attributes(user_id: nil)
        expect(subject).to include(volunteer)
      end
    end
  end
end
