# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Shifts::Recipients::Update do

  let(:object) { described_class.new(shift, event_data) }
  let(:event_data) { {} }
  let(:need) { create(:need_with_shifts) }
  let(:office) { need.office }
  let(:shift) { need.shifts.first! }
  let(:volunteer) { create(:user, offices: [office]) }
  let(:other_volunteer) { create(:user, offices: [office]) }
  let(:social_workers) { office.users.social_workers }
  let(:coordinator) { create(:coordinator, offices: [office]) }
  let!(:office_staff) { [*social_workers, coordinator] }

  describe '#recipients' do
    context 'when a volunteer' do
      context 'assigns themself to a shift' do
        let(:event_data) { { current_user: volunteer } }

        it 'returns social workers and need user' do
          shift.user = volunteer
          need.update!(user: other_volunteer)

          result = object.recipients

          expect(result).to match_array([*social_workers, other_volunteer])
        end
      end

      context 'unassigns themself from a shift' do
        let(:event_data) { { user_was: volunteer, current_user: volunteer } }

        it 'returns social workers and need user' do
          need.user = volunteer # force a user that isn't office staff
          need.save!

          result = object.recipients

          expect(result).to match_array([*social_workers, volunteer])
        end
      end
    end

    context 'when a scheduler' do
      let(:scheduler) { social_workers.first }

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
