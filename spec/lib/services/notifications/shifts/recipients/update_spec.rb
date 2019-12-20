# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Shifts::Recipients::Update do

  let(:object) { described_class.new(shift, event_data) }
  let(:event_data) { {} }
  let(:need) { create(:need_with_shifts) }
  let(:office) { need.office }
  let(:shift) { need.shifts.first! }
  let(:volunteer)       { create(:user, offices: [shift.office], role: User::VOLUNTEER) }
  let(:social_worker)   { create(:user, offices: [shift.office], role: User::SOCIAL_WORKER) }
  let(:coordinator)     { create(:user, offices: [shift.office], role: User::COORDINATOR) }
  let(:admin)           { create(:user, offices: [shift.office], role: User::ADMIN) }
  let(:non_notifiable)  { create(:user, offices: [shift.office], role: User::SOCIAL_WORKER) }

  before do
    [volunteer, social_worker, coordinator, admin].each do |user|
      office_user = OfficeUser.where(user: user, office: shift.office).first
      office_user.update!(send_notifications: true)
    end
  end

  describe '#recipients' do
    context 'when a volunteer' do
      context 'when assigns themself to a shift' do
        let(:event_data) { { current_user: volunteer } }

        it 'returns notifiable office users and need user' do
          shift.user = volunteer
          need.update!(user: non_notifiable)

          result = object.recipients

          expect(result).to match_array([social_worker, coordinator, admin, need.user])
        end
      end

      context 'when unassigns themself from a shift' do
        let(:event_data) { { user_was: volunteer, current_user: volunteer } }

        it 'returns notifiable office users and need user' do
          need.update!(user: volunteer) # force a user that isn't office staff

          result = object.recipients

          expect(result).to match_array([social_worker, coordinator, admin, need.user])
        end
      end
    end

    context 'when a scheduler' do
      context 'when assigns a volunteer' do
        let(:event_data) { { current_user: coordinator } }

        it 'returns notifiable office users, need user, and the assigned user' do
          shift.user = volunteer

          expect(object.recipients).to eql(
            [social_worker, coordinator, admin, need.user, shift.user]
          )
        end
      end

      context 'when unassigns a volunteer' do
        let(:event_data) { { current_user: coordinator, user_was: volunteer } }

        it 'returns notifiable office users, need user, and the user shift was assigned to' do
          shift.user = nil

          expect(object.recipients).to eql(
            [social_worker, coordinator, admin, need.user, volunteer]
          )
        end
      end
    end
  end

end
