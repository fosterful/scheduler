# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Shifts::Recipients::Update do

  let(:object) { described_class.new(shift, event_data) }
  let(:event_data) { {} }
  let(:need) { create(:need_with_shifts) }
  let(:shift) { need.shifts.first! }
  let(:volunteer) { shift.user }
  let(:scheduler) { create(:social_worker, offices: [need.office]) }

  describe '#recipients' do
    context 'when a volunteer' do
      context 'assigns themself to a shift' do
        let(:event_data) { { user_was: nil, current_user: volunteer } }

        it 'returns social workers and need user' do
          scheduler
          shift.user = volunteer

          expect(object.recipients).to match_array([scheduler, need.user])
        end
      end

      context 'unassigns themself from a shift' do
        let(:event_data) { { user_was: volunteer, current_user: volunteer } }

        it 'returns social workers and need user' do
          scheduler

          expect(object.recipients).to match_array([scheduler, need.user])
        end
      end
    end

    context 'when a scheduler' do
      context 'assigns a volunteer' do
        let(:event_data) { { current_user: scheduler, user_was: nil } }

        it 'returns the assigned user' do
          shift.user = volunteer

          expect(object.recipients).to eql([shift.user])
        end
      end

      context 'unassigns a volunteer' do
        let(:user_was) { volunteer }
        let(:event_data) { { current_user: scheduler, user_was: user_was } }

        it 'returns user shift was assigned to' do
          user_was
          shift.user = nil

          expect(object.recipients).to eql([user_was])
        end
      end
    end
  end

end
