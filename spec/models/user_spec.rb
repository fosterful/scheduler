# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build :user }

  it 'has a valid factory' do
    expect(user.valid?).to be(true)
  end

  describe '.volunteerable' do
    let!(:volunteer) { create :user, role: 'volunteer' }
    let!(:coordinator) { create :user, role: 'coordinator' }
    let!(:social_worker) { create :user, role: 'social_worker' }

    it 'returns a list of users that are volunteers or coordinators' do
      expect(described_class.volunteerable).to contain_exactly(volunteer, coordinator)
      expect(described_class.volunteerable).not_to include(social_worker)
    end
  end

  describe '{role}?' do
    it 'checks the role' do
      expect(user.volunteer?).to eq(true)
    end
  end

  describe '#has_at_least_one_office' do
    it 'adds an error if no office is associated' do
      user.offices.clear
      expect(user.valid?).to be(false)
      expect(user.errors.full_messages.first).to eq('At least one office assignment is required')
    end
  end

  describe '#name' do
    context 'first & last name are present' do
      it 'returns first & last name' do
        expect(user.name).to eq('Test User')
      end
    end

    context 'first & last name are nil' do
      it 'returns email address' do
        user.assign_attributes(first_name: nil, last_name: nil)
        expect(user.name).to eq(user.email)
      end
    end
  end

  describe '.available_within' do
    subject { User.available_within(*time.values) }

    let(:time) { { start_at: 1.day.from_now, end_at: 1.day.from_now + 1.hour } }

    context 'user has no blockouts' do
      let!(:user) { create :user }

      it 'includes the user' do
        expect(subject).to include(user)
      end
    end

    context 'user has blockouts with overlap' do
      let(:user) { build :user }
      let!(:blockout) { create :blockout, user: user, **time }

      it 'excludes the user' do
        expect(subject).not_to include(user)
      end
    end

    context 'user has blockouts with no overlap' do
      let(:user) { build :user }
      let!(:blockout) { create :blockout, user: user, start_at: 1.hour.from_now, end_at: 2.hours.from_now }

      it 'includes the user' do
        expect(subject).to include(user)
      end
    end
  end

  describe '.speaks_language' do
    subject { User.speaks_language(language) }

    let(:language) { create :language }

    it 'includes primary and secondary speakers' do
      primary_speaker = create :user, first_language: language
      secondary_speaker = create :user, second_language: language
      expect(subject).to include(primary_speaker, secondary_speaker)
    end
  end

  describe '.coordinators' do # scope test
    it 'supports named scope coordinators' do
      expect(described_class.limit(3).coordinators).to all(be_a(described_class))
    end
  end

  describe '.social_workers' do # scope test
    it 'supports named scope social_workers' do
      expect(described_class.limit(3).social_workers)
        .to all(be_a(described_class))
    end
  end

  describe '.volunteers' do # scope test
    it 'supports named scope volunteers' do
      expect(described_class.limit(3).volunteers).to all(be_a(described_class))
    end
  end

  describe '.schedulers' do # scope test
    it 'supports named scope schedulers' do
      expect(described_class.limit(3).schedulers).to all(be_a(described_class))
    end
  end

  describe '.with_phone' do # scope test
    it 'supports named scope with_phone' do
      expect(described_class.limit(3).with_phone).to all(be_a(described_class))
    end
  end
  context 'reporting' do
    let(:lang1) { create(:language, name: 'Lang1') }
    let(:lang2) { create(:language, name: 'Lang2') }
    let(:lang3) { create(:language, name: 'Lang3') }
    let(:race1) { create(:race, name: 'Race1') }
    let(:race2) { create(:race, name: 'Race2') }
    let(:race3) { create(:race, name: 'Race3') }
    let(:wa_address1) { build(:address, :wa)}
    let(:wa_address2) { build(:address, :wa, county: 'Lewis')}
    let(:wa_office1) { create(:wa_office, address: wa_address1).tap { wa_address1.save!} }
    let(:wa_office2) { create(:wa_office, address: wa_address2).tap { wa_address2.save!} }
    let(:or_office) { create(:or_office) }
    let(:wa_sw1) { create(:user, role: 'social_worker', offices: [wa_office1])}
    let(:wa_sw2) { create(:user, role: 'social_worker', offices: [wa_office2])}
    let(:or_sw) { create(:user, role: 'social_worker', offices: [or_office])}
    let(:wa_user1) { create(:user, offices: [wa_office1], race: race1, first_language: lang1, second_language: lang2) }
    let(:wa_user2) { create(:user, offices: [wa_office2], race: race1) }
    let(:wa_user3) { create(:user, offices: [wa_office2], race: race2, first_language: lang3, second_language: lang2) }
    let(:or_user) { create(:user, offices: [or_office], race: race3, first_language: lang2) }
    let(:wa_need1) { create(:need_with_shifts, user: wa_sw1, number_of_children: 1, expected_duration: 60, office: wa_office1, preferred_language: lang1) }
    let(:wa_need2) { create(:need_with_shifts, user: wa_sw2, number_of_children: 2, expected_duration: 240, office: wa_office2, preferred_language: lang1) }
    let(:wa_need3) { create(:need_with_shifts, user: wa_sw2, number_of_children: 7, expected_duration: 120, office: wa_office2, preferred_language: lang1) }
    let!(:unmet_wa_need) { create(:need_with_shifts, user: wa_sw2, number_of_children: 2, expected_duration: 120, office: wa_office2, preferred_language: lang3) }
    let(:or_need) { create(:need_with_shifts, user: or_sw, number_of_children: 3, expected_duration: 120, office: or_office, preferred_language: lang2) }

    before do
      or_need.shifts.first.update(user: or_user)
      wa_need1.shifts.first.update(user: wa_user1)
      wa_need2.shifts.update_all(user_id: wa_user2.id)
      wa_need3.shifts.first.update(user: wa_user3)
      wa_need3.shifts.last.update(user: wa_user2)
    end

    describe '.total_volunteers_by_race' do
      it 'returns the number of volunteers grouped by race name' do
        expect(described_class.total_volunteers_by_race).to eql(race1.name => 2, race2.name => 1, race3.name => 1)
      end
    end

    describe '.total_volunteers_by_spoken_language' do
      it 'returns the number of volunteers grouped by race name' do
        expect(described_class.total_volunteers_by_spoken_language).to eql(lang1.name => 1, lang2.name => 3, lang3.name => 1)
      end
    end

    describe '.total_volunteer_minutes_by_user' do
      it 'returns the volunteer minutes grouped by user_id' do
        expect(described_class.total_volunteer_minutes_by_user).to eql(or_user.id => 60, wa_user1.id => 60, wa_user2.id => 300, wa_user3.id => 60)
      end
    end
  end

  describe '#has_at_least_one_age_range' do
    it 'has_at_least_one_age_range' do
      user = described_class.new

      user.has_at_least_one_age_range

      expect(user.errors[:base])
        .to include('At least one age range selection is required')
    end
  end

  describe '#scheduler?' do
    it 'scheduler?' do
      result = user.scheduler?

      expect(result).to be false
    end
  end

end
