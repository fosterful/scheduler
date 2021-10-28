# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Shifts::Message::Update do

  let(:object) { described_class.new(shift, event_data) }
  let(:event_data) { {} }
  let(:volunteer) { create(:user, first_name: 'Barney', last_name: 'Rubble') }
  let(:scheduler) do
    u = create(:user, role: User::SOCIAL_WORKER)
    u.offices << shift.office
    u
  end
  let(:shift) { create(:shift, start_at: starts, duration: 120) }
  let(:starts) { Time.zone.parse('2019-05-23 11:15:00 -07:00') }

  describe '#message' do
    context 'when a volunteer' do
      context 'assigns themself to a shift' do
        let(:event_data) { { user_was: nil, current_user: volunteer } }

        it 'returns expected message' do
          shift.user = volunteer

          result = object.message

          expect(result).to eql('Barney Rubble has taken the shift Thu, '\
                                  'May 23 from 11:15am to 01:15pm.')
          expect(result).to be_frozen
        end
      end

      context 'unassigns themself from a shift' do
        let(:event_data) { { user_was: volunteer, current_user: volunteer } }

        it 'returns expected message' do
          result = object.message

          expect(result).to eql('Barney Rubble has unassigned themself from '\
                                  'the 11:15am to 01:15pm shift Thu, May 23.')
          expect(result).to be_frozen
        end
      end
    end

    context 'when a scheduler' do
      context 'assigns a volunteer' do
        let(:event_data) { { current_user: scheduler, user_was: nil } }

        it 'returns expected message' do
          shift.user = volunteer

          result = object.message

          expect(result).to eql('Thank You! Please be ready to show proof of vaccination at the door. See you soon.')
          expect(result).to be_frozen
        end
      end

      context 'unassigns a volunteer' do
        let(:event_data) { { current_user: scheduler, user_was: volunteer } }

        it 'returns expected message' do
          result = object.message

          expect(result).to eql('You have been unassigned from the 11:15am to '\
                                  '01:15pm shift Thu, May 23.')
          expect(result).to be_frozen
        end
      end
    end
  end

end
