# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Needs::Recipients::Update do
  subject { described_class.new(need).recipients }

  let(:need) do
    build(:need).tap do |need|
      need.update(shifts: Services::BuildNeedShifts.call(need))
    end
  end

  let(:user) { build(:user) }

  describe '#recipients' do

    it 'does not include non-volunteers' do
      need.office.users << (social_worker = build(:user, role: 'social_worker'))

      expect(subject).not_to include(social_worker)
    end

    context 'with multiple users' do
      it 'returns volunteers notified' do
        users = build_list(:user, 2, age_ranges: need.age_ranges)
        need.office.users << users

        expect(subject).to include(*users)
      end
    end

    context 'with volunteers that are blocked out' do
      let(:blockout) do
        build(:blockout, start_at: need.start_at, end_at: need.end_at)
      end
      let(:blockout_user) {
        build(:user, age_ranges: need.age_ranges, blockouts: [blockout])
      }

      before { need.office.users << [user, blockout_user] }

      it 'excludes the unavailable volunteers' do
        expect(subject).not_to include(blockout_user)
      end
    end

    context 'with volunteers that have marked themselves unavailable' do
      it 'excludes the unavailable volunteers' do
        need.office.users << [user]
        need.update(unavailable_user_ids: [user.id])

        expect(subject).to eq([need.user])
      end
    end

    context 'with users already notified' do
      let(:user) { create(:user, age_ranges: need.age_ranges) }

      it 'notifies users again' do
        need.office.users << user
        need.update(notified_user_ids: [user.id])

        expect(subject).to include(user)
      end
    end

    context 'preferred language was specified' do
      let(:language) { build(:language, name: 'gibberish') }
      let(:language_speaking_user) do
        build(:user, first_language: language, age_ranges: need.age_ranges)
      end

      before do
        need.update(preferred_language: language)
        need.office.users << [user, language_speaking_user]
      end

      it 'includes only users that speak the language and need creator' do
        expect(subject).to contain_exactly(language_speaking_user, need.user)
      end
    end

    context 'age ranges were specified' do
      let(:age_range) { build(:age_range, min: 10, max: 13) }
      let(:user_with_age_range) { build(:user, age_ranges: [age_range]) }

      before do
        need.age_ranges << age_range
        need.office.users << [user, user_with_age_range]
      end

      it 'includes only users that include the age_range and need creator' do
        expect(subject).to contain_exactly(user_with_age_range, need.user)
      end
    end
  end

end
