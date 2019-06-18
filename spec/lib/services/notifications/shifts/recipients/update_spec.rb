# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Shifts::Recipients::Update do

  let(:object) { described_class.new(shift, event_data) }
  let(:event_data) { {} }
  let(:need) { create(:need_with_shifts) }
  let(:shift) { need.shifts.first! }
  let(:volunteer) { shift.user }
  let(:scheduler) { create(:social_worker, offices: [need.office]) }
  let(:coordinator) { create(:coordinator, offices: [need.office]) }
  let(:social_workers) { [scheduler, coordinator] }

  describe '#recipients' do
    context 'when a volunteer' do
      context 'assigns themself to a shift' do
        let(:event_data) { { current_user: volunteer } }

        it 'returns social workers and need user' do
          social_workers
          shift.user = volunteer

          expect(object.recipients).to match_array([*social_workers, need.user])
        end
      end

      context 'unassigns themself from a shift' do
        let(:event_data) { { user_was: volunteer, current_user: volunteer } }

        it 'returns social workers and need user' do
          social_workers

          expect(object.recipients).to match_array([*social_workers, need.user])
        end
      end
    end

    context 'when a scheduler' do
      context 'assigns a volunteer' do
        let(:event_data) { { current_user: scheduler } }

        it 'returns the assigned user' do
          shift.user = volunteer

          expect(object.recipients).to eql([shift.user])
        end
      end

      context 'unassigns a volunteer' do
        let(:event_data) { { current_user: scheduler, user_was: volunteer } }

        it 'returns user shift was assigned to' do
          shift.user = nil

          expect(object.recipients).to eql([volunteer])
        end
      end
    end
  end

end
