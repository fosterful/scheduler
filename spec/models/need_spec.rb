# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Need, type: :model do
  let(:need) { create(:need) }
  let(:shift) { create(:shift, need: need) }
  let(:spanish) { Language.find_by!(name: 'Spanish') }
  let(:new_user) { create(:user) }

  it 'has a valid factory' do
    expect(need.valid?).to be(true)
  end

  describe '#effective_start_at' do
    it 'returns need start at if no shifts' do
      result = need.effective_start_at

      expect(result).to eql(need.start_at)
    end

    it 'returns need start at if no shifts are earlier' do
      need.shifts << build(:shift, start_at: need.start_at)

      result = need.effective_start_at

      expect(result.to_s(:db)).to eql(need.start_at.to_s(:db))
    end

    it 'returns earliest shift start at if earlier than need start at' do
      starts = need.start_at.advance(hours: -1)
      need.shifts << build(:shift, start_at: starts)
      need.save!

      result = need.effective_start_at

      expect(result.to_s(:db)).to eql(starts.to_s(:db))
    end
  end

  describe '.current' do # scope test
    it 'supports named scope current' do
      expect(described_class.limit(3).current).to all(be_a(described_class))
    end
  end

  context 'reporting' do
    let(:wa_address1) { build(:address, :wa) }
    let(:wa_address2) { build(:address, :wa, county: 'Lewis') }
    let(:wa_office1) { create(:wa_office, address: wa_address1) }
    let(:wa_office2) { create(:wa_office, address: wa_address2) }
    let(:or_office) { create(:or_office) }
    let(:wa_sw1) { create(:user, role: 'social_worker', offices: [wa_office1]) }
    let(:wa_sw2) { create(:user, role: 'social_worker', offices: [wa_office2]) }
    let(:or_sw) { create(:user, role: 'social_worker', offices: [or_office]) }
    let(:wa_user1) { create(:user, offices: [wa_office1]) }
    let(:wa_user2) { create(:user, offices: [wa_office2]) }
    let(:or_user) { create(:user, offices: [or_office]) }
    let(:wa_need1) { create(:need_with_shifts, user: wa_sw1, number_of_children: 1, expected_duration: 120, office: wa_office1) }
    let(:wa_need2) { create(:need_with_shifts, user: wa_sw2, number_of_children: 2, expected_duration: 240, office: wa_office2) }
    let!(:unmet_wa_need) { create(:need_with_shifts, user: wa_sw2, number_of_children: 2, expected_duration: 120, office: wa_office2) }
    let(:or_need) { create(:need_with_shifts, user: or_sw, number_of_children: 3, expected_duration: 120, office: or_office) }

    before do
      or_need.shifts.first.update(user: or_user) # 3 child served
      wa_need1.shifts.first.update(user: wa_user1) # 1 child served
      wa_need1.shifts.last.update(user: wa_user2) # 1 child served
      wa_need2.shifts.update_all(user_id: wa_user2.id) # 2 child served (total of 3)
    end

    describe '.total_children_served' do
      it 'returns the total number of children served' do
        expect(described_class.total_children_served).to eql(wa_need1.number_of_children + wa_need2.number_of_children + or_need.number_of_children)
      end
    end
  end

  describe '#preferred_language' do
    it 'preferred_language' do
      result = need.preferred_language

      expect(result).to be_an_instance_of(NullLanguage)
    end

    it 'preferred_language' do
      need.preferred_language = spanish

      result = need.preferred_language

      expect(result).to eql(spanish)
    end
  end

  describe '#end_at' do
    it 'end_at' do
      result = need.end_at

      expect(result).to be_within(5.seconds).of(Time.zone.now.advance(hours: 2))
    end
  end

  describe '#expired?' do
    it 'expired?' do
      result = need.expired?

      expect(result).to be false
    end

    it 'returns true if expired' do
      need.start_at = Time.zone.now.advance(hours: -3)

      result = need.expired?

      expect(result).to be true
    end
  end

  describe '#notification_candidates' do
    it 'returns empty array if no office users with phone' do
      result = need.notification_candidates

      expect(result).to match_array([])
    end

    it 'returns office users with phone that have not been notified' do
      need.office.users << new_user

      result = need.notification_candidates

      expect(result.to_a).to eql([new_user])
    end
  end

  describe '#users_to_notify' do
    it 'returns nothing if no shifts' do
      result = need.users_to_notify

      expect(result).to be_empty
    end

    it 'users_to_notify' do
      need.office.users << new_user
      need.shifts << shift
      new_user.age_ranges << shift.age_ranges

      result = need.users_to_notify

      expect(result.to_a).to eql([new_user])
    end
  end

end
