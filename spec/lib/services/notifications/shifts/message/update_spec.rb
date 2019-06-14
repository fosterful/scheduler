# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Shifts::Message::Update do

  let(:object) { described_class.call(shift, event_data) }
  let(:event_data) { {} }
  let(:volunteer) { create(:user) }
  let(:scheduler) do
    u = create(:user, role: User::SOCIAL_WORKER)
    u.offices << shift.office
    u
  end
  let(:shift) { create(:shift, start_at: starts, duration: 120) }
  let(:starts) { Time.zone.parse('2019-05-23 11:15:00 -07:00') }

  describe '#call' do
    context 'when a volunteer' do
      context 'assigns themself to a shift' do
        let(:event_data) { { user_was: nil, current_user: volunteer } }

        it 'returns expected message' do
          shift.user = volunteer

          expect(object).to eql('A Volunteer has taken the shift Thu, May 23 '\
                                  'from 11:15am to 01:15pm.')
        end
      end

      context 'unassigns themself from a shift' do
        let(:event_data) { { user_was: volunteer, current_user: volunteer } }

        it 'returns expected message' do
          expect(object).to eql('A Volunteer has unassigned themself from the '\
                                  '11:15am to 01:15pm shift Thu, May 23.')
        end
      end
    end

    context 'when a scheduler' do
      context 'assigns a volunteer' do
        let(:event_data) { { current_user: scheduler, user_was: nil } }

        it 'returns expected message' do
          shift.user = volunteer

          expect(object).to eql('You have been assigned a shift Thu, May 23 '\
                                  'from 11:15am to 01:15pm.')
        end
      end

      context 'unassigns a volunteer' do
        let(:event_data) { { current_user: scheduler, user_was: volunteer } }

        it 'returns expected message' do
          expect(object).to eql('You have been unassigned from the 11:15am to '\
                                  '01:15pm shift Thu, May 23.')
        end
      end
    end
  end

end
