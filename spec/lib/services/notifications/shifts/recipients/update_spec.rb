# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Shifts::Recipients::Update do

  let(:object) { described_class.new(shift, event_data) }
  let(:event_data) { {} }
  let(:need) { create(:need_with_shifts) }
  let(:shift) { need.shifts.first! }
  let(:volunteer) { create(:user, offices: [need.office]) }
  let(:social_worker) { create(:social_worker, offices: [need.office]) }

  describe '#recipients' do
    context 'when a volunteer' do
      context 'assigns themself to a shift' do
        it 'notifies the volunteer' do
          allow(SendTextMessageWorker).to receive(:perform_async)
          shift.assign_attributes(user_id: volunteer.id)
          expect(SendTextMessageWorker).to receive(:perform_async).with(volunteer.phone, "You have taken the shift #{starting_day(shift)} from #{shift_duration_in_words(shift)}. #{Rails.application.routes.url_helpers.need_url(need)}")
          object.recipients
        end

        it 'notifies the social workers' do
          shift.assign_attributes(user_id: volunteer.id)

          expect(object.recipients).to include(social_worker)
        end

        it 'notifies the need creator' do
          shift.assign_attributes(user_id: volunteer.id)

          expect(object.recipients).to include(coordinator)
        end
      end

      context 'unassigns themself from a shift' do

        before { shift.update(user: volunteer) }

        it 'notifies the social workers' do
          shift.assign_attributes(user_id: nil)

          expect(object.recipients).to include(social_worker)
        end

        it 'notifies the need creator' do
          shift.assign_attributes(user_id: nil)

          expect(object.recipients).to include(coordinator)
        end
      end
    end

    context 'when a scheduler' do
      context 'assigns a volunteer' do
        it 'notifies the user being assigned' do
          shift.assign_attributes(user_id: volunteer.id)

          expect(object.recipients).to include(volunteer)
        end
      end

      context 'unassigns a volunteer' do
        before { shift.update(user: volunteer) }

        it 'notifies the user being unassigned' do
          shift.assign_attributes(user_id: nil)

          expect(object.recipients).to include(volunteer)
        end
      end
    end
  end

end
