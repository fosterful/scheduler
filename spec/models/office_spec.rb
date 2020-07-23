# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Office, type: :model do
  let(:office) { build :office }

  it 'has a valid factory' do
    expect(office.valid?).to be(true)
  end

  context 'when reporting' do
    let(:lang1) { create(:language, name: 'Lang1') }
    let(:lang2) { create(:language, name: 'Lang2') }
    let(:lang3) { create(:language, name: 'Lang3') }
    let(:wa_address1) { build(:address, :wa) }
    let(:wa_address2) { build(:address, :wa, county: 'Lewis') }
    let(:wa_office1) do
      create(:wa_office, address: wa_address1).tap { wa_address1.save! }
    end
    let(:wa_office2) do
      create(:wa_office, address: wa_address2).tap { wa_address2.save! }
    end
    let(:or_office) { create(:or_office) }
    let(:wa_sw1) { create(:user, role: 'social_worker', offices: [wa_office1]) }
    let(:wa_sw2) { create(:user, role: 'social_worker', offices: [wa_office2]) }
    let(:or_sw) { create(:user, role: 'social_worker', offices: [or_office]) }
    let(:wa_user1) { create(:user, offices: [wa_office1]) }
    let(:wa_user2) { create(:user, offices: [wa_office2]) }
    let(:wa_user3) { create(:user, offices: [wa_office2]) }
    let(:or_user) { create(:user, offices: [or_office]) }
    let(:wa_need1) do
      create(:need_with_shifts,
             user:               wa_sw1,
             number_of_children: 1,
             expected_duration:  60,
             office:             wa_office1,
             preferred_language: lang1)
    end
    let(:wa_need2) do
      create(:need_with_shifts,
             user:               wa_sw2,
             number_of_children: 2,
             expected_duration:  240,
             office:             wa_office2,
             preferred_language: lang1)
    end
    let(:wa_need3) do
      create(:need_with_shifts,
             user:               wa_sw2,
             number_of_children: 7,
             expected_duration:  120,
             office:             wa_office2,
             preferred_language: lang1)
    end
    let!(:unmet_wa_need) do
      create(:need_with_shifts,
             user:               wa_sw2,
             number_of_children: 2,
             expected_duration:  120,
             office:             wa_office2,
             preferred_language: lang3)
    end
    let(:or_need) do
      create(:need_with_shifts,
             user:               or_sw,
             number_of_children: 3,
             expected_duration:  120,
             office:             or_office,
             preferred_language: lang2)
    end

    before do
      or_need.shifts.first.update(user: or_user)
      wa_need1.shifts.first.update(user: wa_user1)
      wa_need2.shifts.update_all(user_id: wa_user2.id)
      wa_need3.shifts.first.update(user: wa_user3)
      wa_need3.shifts.last.update(user: wa_user2)
    end

    describe '.total_volunteer_hours_by_office' do
      it 'returns the total volunteer hours grouped by office' do
        expect(described_class.total_volunteer_hours_by_office(nil, nil))
          .to eql(or_office.id => 1.0, wa_office1.id => 1.0, wa_office2.id => 6.0)
      end

      context 'with a date range' do
        it 'returns the total hours filtered by dates' do
          expect(described_class.total_volunteer_hours_by_office('Jan 1, 2010', 'Feb 2, 2030'))
            .to eql(or_office.id => 1.0, wa_office1.id => 1.0, wa_office2.id => 6.0)

          expect(described_class.total_volunteer_hours_by_office(nil, 'Feb 2, 2030'))
            .to eql(or_office.id => 1.0, wa_office1.id => 1.0, wa_office2.id => 6.0)

          expect(described_class.total_volunteer_hours_by_office('Jan 1, 2010', nil))
            .to eql(or_office.id => 1.0, wa_office1.id => 1.0, wa_office2.id => 6.0)
        end

        it 'does not use office\'s needs that are out of range' do
          or_need.update(start_at: 1.month.from_now)

          expect(described_class.total_volunteer_hours_by_office(nil, Time.zone.now.strftime('%b %e, %Y')))
            .to eql(wa_office1.id => 1.0, wa_office2.id => 6.0)
        end
      end
    end

    describe '.total_volunteer_hours_by_state' do
      it 'returns the total volunteer hours groupe by state' do
        expect(described_class.total_volunteer_hours_by_state(nil, nil))
          .to eql('OR' => 1.0, 'WA' => 7.0)
      end
    end

    describe '.total_volunteer_hours_by_county' do
      it 'returns the total volunteer hours groupe by county' do
        expect(described_class.total_volunteer_hours_by_county('WA'))
          .to eql('Lewis' => 6.0, 'Clark' => 1.0)
      end
    end

    describe '.total_children_served_by_office' do
      it 'returns the total children served grouped by office' do
        expect(described_class.total_children_served_by_office(nil, nil))
          .to eql(or_office.id => 3, wa_office1.id => 1, wa_office2.id => 9)
      end
    end

    describe '.total_children_served_by_state' do
      it 'returns the total children served group by state' do
        expect(described_class.total_children_served_by_state(nil, nil))
          .to eql('OR' => 3, 'WA' => 10)
      end
    end

    describe '.total_children_served_by_county' do
      it 'returns the total children served in given state grouped by county' do
        expect(described_class.total_children_served_by_county('WA'))
          .to eql('Lewis' => 9, 'Clark' => 1)
      end
    end

    describe '.total_children_by_demographic' do
      it 'returns the total children with each preferred_language' do
        expect(described_class.total_children_by_demographic(nil, nil))
          .to eql(lang1.name => 10, lang2.name => 3, lang3.name => 2)
      end
    end
  end

  describe '#notifiable_users' do
    it 'notifiable_users' do
      office = create(:office)

      result = office.notifiable_users

      expect(result).to match_array([])
    end
  end

  describe '.with_claimed_shifts' do # scope test
    it 'supports named scope with_claimed_shifts' do
      result = described_class.with_claimed_shifts

      expect(result).to all(be_a(described_class))
      expect(result).to be_empty
    end
  end

  describe '.with_claimed_needs' do # scope test
    it 'supports named scope with_claimed_needs' do
      result = described_class.with_claimed_needs

      expect(result).to all(be_a(described_class))
      expect(result).to be_empty
    end
  end

  describe '.total_volunteers_by_race' do
    it 'total_volunteers_by_race' do
      result = described_class.total_volunteers_by_race(nil, nil)

      expect(result).to be_empty
    end
  end

end
