# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Needs::Create do
  subject { described_class.new(need, notifier).call }

  let(:notifier) { double }
  let(:need) do
    create(:need, start_at: Date.parse('2019-05-23')).tap do |need|
      need.update(shifts: Services::BuildNeedShifts.call(need))
    end
  end
  let(:msg) do
    'A new need starting Thu, May 23 at 12:00am has opened up at your local '\
      "office! http://localhost:3000/needs/#{need.id}"
  end
  let(:volunteer) { build(:user) }
  let(:social_worker) { build(:social_worker) }

  describe '#call' do
    it 'does not include the need user/creator' do
      expect(need.office.users).to include(need.user)
      expect(notifier).to receive(:send_messages).with([], msg)

      subject
    end

    it 'does not include non-volunteers' do
      need.office.users << social_worker
      need.office.users << volunteer

      expect(notifier).to receive(:send_messages).with([volunteer.phone], msg)

      subject
    end

    context 'with multiple users' do
      it 'returns volunteers notified' do
        users = build_list(:user, 2, age_ranges: need.age_ranges)
        need.office.users << users

        expect(notifier).to receive(:send_messages)
                              .with(users.map(&:phone), msg)

        subject
      end
    end

    context 'with volunteers that are not available' do
      let(:blockout) do
        build(:blockout, start_at: need.start_at, end_at: need.end_at)
      end
      let(:unavailable_user) { build(:user, blockouts: [blockout]) }

      it 'excludes the unavailable volunteers' do
        need.office.users << [user, unavailable_user]

        expect(notifier).to receive(:send_messages).with([user.phone], msg)

        subject
      end
    end

    context 'with users already notified' do
      it 'does not notify users again' do
        need.office.users << user
        need.update(notified_user_ids: [user.id])

        expect(notifier).to receive(:send_messages).with([], msg)

        subject
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

      it 'includes only users that speak the language' do
        expect(notifier).to receive(:send_messages)
                              .with([language_speaking_user.phone], msg)

        subject
      end
    end

    context 'age ranges were specified' do
      let(:age_range) { build(:age_range, min: 10, max: 13) }
      let(:user_with_age_range) { build(:user, age_ranges: [age_range]) }

      before do
        need.age_ranges << age_range
        need.office.users << [user, user_with_age_range]
      end

      it 'includes only users that include the age_range' do
        expect(notifier).to receive(:send_messages)
                              .with([user_with_age_range.phone], msg)

        subject
      end
    end
  end

end
