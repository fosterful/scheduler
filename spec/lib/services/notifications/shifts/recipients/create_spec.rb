# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Shifts::Recipients::Create do

  let(:object) { described_class.new(shift, event_data) }
  let(:event_data) { {} }
  let(:shift) { need.shifts.first! }
  let(:need) { create(:need_with_shifts) }
  let(:social_worker) { create(:user, role: 'social_worker') }

  let(:user) { create(:user) }

  describe '#call' do
    it 'does not include the need user/creator' do
      expect(shift.need.office.users).to include(shift.need.user)
      expect(object.recipients).not_to include(shift.need.user)
    end

    it 'does not include non-volunteers' do
      shift.need.office.users << social_worker

      expect(object.recipients).not_to include(social_worker)
    end

    context 'with multiple users' do
      it 'returns volunteers notified' do
        users = build_list(:user, 2, age_ranges: need.age_ranges)
        need.office.users << users

        expect(object.recipients).to include(*users)
      end
    end

    context 'with volunteers that are not available' do
      let(:blockout) do
        create(:blockout, start_at: shift.start_at, end_at: shift.end_at)
      end
      let(:unavailable_user) { create(:user, blockouts: [blockout]) }

      before { shift.need.office.users << [user, unavailable_user] }

      it 'excludes the unavailable volunteers' do
        expect(object.recipients).not_to include(unavailable_user)
      end
    end

    context 'with users already notified' do
      it 'does not notify users again' do
        shift.need.office.users << user
        shift.need.update(notified_user_ids: [user.id])

        expect(object.recipients).not_to include(user)
      end
    end

    context 'preferred language was specified' do
      let(:language) { create(:language, name: 'gibberish') }
      let(:language_speaking_user) do
        create(:user, first_language: language, age_ranges: need.age_ranges)
      end

      before do
        shift.need.update(preferred_language: language)
        shift.need.office.users << [user, language_speaking_user]
      end

      it 'includes only users that speak the language' do
        expect(object.recipients).to contain_exactly(language_speaking_user)
      end
    end

    context 'age ranges were specified' do
      let(:age_range) { create(:age_range, min: 10, max: 13) }
      let(:user_with_age_range) { create(:user, age_ranges: [age_range]) }

      before do
        shift.need.age_ranges << age_range
        shift.need.office.users << [user, user_with_age_range]
      end

      it 'includes only users that include the age_range' do
        expect(object.recipients).to contain_exactly(user_with_age_range)
      end
    end

  end

end
