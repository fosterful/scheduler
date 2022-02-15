# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shift, type: :model do
  let(:shift) { create :shift }
  let(:second_shift) do
    shift.save! unless shift.persisted?
    create(:shift, need: shift.need, start_at: shift.end_at, duration: 60)
  end

  it 'has a valid factory' do
    expect(shift.valid?).to be(true)
  end

  describe '#notify_user_of_cancelation' do
    it 'notifies the user when the shift is deleted' do
      shift = create(:shift,
                     start_at: Time.zone.parse('2019-01-09 09:00:00 -0800'),
                     user:     create(:user))

      expect { shift.destroy }
        .to change(SendTextMessageWorker.jobs, :size)
        .by(1)
    end
  end

  describe '#end_at' do
    it 'end_at' do
      result = shift.end_at

      expect(result).to be_within(5.seconds).of(Time.zone.now.advance(hours: 1))
    end
  end

  describe '#expired?' do
    it 'expired?' do
      result = shift.expired?

      expect(result).to be false
    end

    it 'returns true if expired' do
      shift.start_at = Time.zone.now.advance(hours: -3)

      result = shift.expired?

      expect(result).to be true
    end
  end

  describe '#users_to_notify' do
    it 'users_to_notify' do
      result = shift.users_to_notify

      expect(result).not_to be_nil
    end
  end

  describe '#duration_in_words' do
    it 'duration_in_words' do
      starts = Time.zone.parse('2019-04-22 12:34:56 -0700')
      allow(shift).to receive(:start_at).and_return(starts)

      result = shift.duration_in_words

      expect(result).to eql('12:34pm to 01:34pm')
    end
  end

  describe '#user_need_shifts' do
    it 'returns nil if no user associated with shift' do
      result = shift.user_need_shifts
      expect(result).to be_nil
    end

    it 'returns a list of all shifts for a user for a given need' do
      shift = create(:shift,
        start_at: Time.zone.parse('2019-01-09 09:00:00 -0800'),
        user:     create(:user))
      result = shift.user_need_shifts
      expect(result.first.id).to equal(shift.id)
    end
  end

  describe '#can_destroy?' do
    it 'returns false if only one shift' do
      result = shift.can_destroy?

      expect(result).to be false
    end

    it 'returns true if more than one shift' do
      second_shift

      result = shift.can_destroy?

      expect(result).to be true
    end
  end

  describe '.claimed' do # scope test
    it 'supports named scope claimed' do
      shift = create(:shift)
      shift.update!(user: create(:user))

      result = described_class.limit(3).claimed

      expect(result).to match_array([shift])
    end
  end

  describe 'after_create :clear_unavailable_users' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:need) { shift.need }

    before { need.update(unavailable_user_ids: [user.id, user2.id]) }

    it "clears the need's unavailable_user_ids on create" do
      expect(need.unavailable_user_ids).to eq([user.id, user2.id])
      second_shift
      expect(need.unavailable_user_ids).to be_empty
    end
  end

  describe 'after_update :make_user_available' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:need) { shift.need }

    before { need.update(unavailable_user_ids: [user.id, user2.id]) }

    it 'removes the assigned user from the list of unavailable users' do
      expect(need.unavailable_user_ids).to eq([user.id, user2.id])
      shift.update!(user: user)
      expect(need.unavailable_user_ids).to eq([user2.id])
    end
  end

  describe '.for_survey_notification' do
    subject { Shift.for_survey_notification }

    # User with multiple shifts, same need
    let(:user1) { create :user }
    let(:need) { create :need }
    let!(:shift1) { create :shift, need: need, user: user1, start_at: 1.hour.ago - 30.minutes }
    let!(:shift2) { create :shift, need: need, user: user1, start_at: 2.hours.ago - 30.minutes }

    # User with multiple shifts, different needs
    let(:user2) { create :user }
    let!(:shift3) { create :shift, user: user2, start_at: 1.hour.ago - 30.minutes }
    let!(:shift4) { create :shift, user: user2, start_at: 1.hours.ago - 45.minutes }

    # User who's shift hasn't ended yet
    let(:user3) { create :user }
    let!(:shift5) { create :shift, user: user3, start_at: 1.hours.ago }

    # User who's shift has ended, but the survey was sent already
    let(:user4) { create :user }
    let!(:shift6) { create :shift, user: user4, start_at: 1.hour.ago - 30.minutes }
    let!(:shift_survey) { create :shift_survey, need: shift6.need, user: shift6.user }

    # User who's shift is in the future
    let(:user5) { create :user }
    let!(:shift7) { create :shift, user: user5, start_at: 4.hours.from_now }

    it 'returns the expected shifts' do
      expect(subject).to be_a(ActiveRecord::Relation)

      # User with multiple shifts, same need
      expect(subject).to include(shift1)
      expect(subject).not_to include(shift2)

      # User with multiple shifts, different needs
      expect(subject).to include(shift3)
      expect(subject).to include(shift4)

      # User who's shift hasn't ended yet
      expect(subject).not_to include(shift5)

      # User who's shift has ended, but the survey was sent already
      expect(subject).not_to include(shift6)

      # User who's shift is in the future
      expect(subject).not_to include(shift7)
    end
  end
end
