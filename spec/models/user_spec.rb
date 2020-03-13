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
      expect(described_class.volunteerable)
        .to contain_exactly(volunteer, coordinator)
      expect(described_class.volunteerable).not_to include(social_worker)
    end
  end

  describe '{role}?' do
    it 'checks the role' do
      expect(user.volunteer?).to eq(true)
    end
  end

  describe '#at_least_one_office' do
    it 'adds an error if no office is associated' do
      user.offices.clear
      expect(user.valid?).to be(false)
      expect(user.errors.full_messages.first)
        .to eq('At least one office assignment is required')
    end
  end

  describe '#name' do
    context 'when first & last name are present' do
      it 'returns first & last name' do
        expect(user.name).to eq('Test User')
      end
    end

    context 'when first & last name are nil' do
      it 'returns email address' do
        user.assign_attributes(first_name: nil, last_name: nil)
        expect(user.name).to eq(user.email)
      end
    end
  end

  describe '.exclude_blockouts' do
    subject { described_class.exclude_blockouts(*time.values) }

    let(:time) { { start_at: 1.day.from_now, end_at: 1.day.from_now + 1.hour } }

    context 'when user has no blockouts' do
      let!(:user) { create :user }

      it 'includes the user' do
        expect(subject).to include(user)
      end
    end

    context 'when user has blockouts with overlap' do
      let(:user) { build :user }
      let!(:blockout) { create :blockout, user: user, **time }

      it 'excludes the user' do
        expect(subject).not_to include(user)
      end
    end

    context 'when user has blockouts with no overlap' do
      let(:user) { build :user }
      let!(:blockout) do
        create(:blockout,
               user:     user,
               start_at: 1.hour.from_now,
               end_at:   2.hours.from_now)
      end

      it 'includes the user' do
        expect(subject).to include(user)
      end
    end
  end

  describe '.speaks_language' do
    subject { described_class.speaks_language(language) }

    let(:language) { create :language }

    it 'includes primary and secondary speakers' do
      primary_speaker   = create :user, first_language: language
      secondary_speaker = create :user, second_language: language
      expect(subject).to include(primary_speaker, secondary_speaker)
    end
  end

  describe '.coordinators' do # scope test
    it 'supports named scope coordinators' do
      expect(described_class.coordinators).to all(be_a(described_class))
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
      expect(described_class.volunteers).to all(be_a(described_class))
    end
  end

  describe '.schedulers' do # scope test
    it 'supports named scope schedulers' do
      expect(described_class.schedulers).to all(be_a(described_class))
    end
  end

  describe '.with_phone' do # scope test
    it 'supports named scope with_phone' do
      expect(described_class.limit(3).with_phone).to all(be_a(described_class))
    end
  end

  context 'when reporting' do
    let(:lang1) { create(:language, name: 'Lang1') }
    let(:lang2) { create(:language, name: 'Lang2') }
    let(:lang3) { create(:language, name: 'Lang3') }
    let(:race1) { create(:race, name: 'Race1') }
    let(:race2) { create(:race, name: 'Race2') }
    let(:race3) { create(:race, name: 'Race3') }
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
    let(:wa_user1) do
      create(:user,
             offices:         [wa_office1],
             race:            race1,
             first_language:  lang1,
             second_language: lang2)
    end
    let(:wa_user2) do
      create(:user, offices: [wa_office2], race: race1, first_language: lang2)
    end
    let(:wa_user3) do
      create(:user,
             offices:         [wa_office2],
             race:            race2,
             first_language:  lang3,
             second_language: lang2)
    end
    let(:or_user) do
      create(:user, offices: [or_office], race: race3, first_language: lang2)
    end
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
      wa_need2.shifts.find_each { |s| s.update!(user_id: wa_user2.id) }
      wa_need3.shifts.first.update(user: wa_user3)
      wa_need3.shifts.last.update(user: wa_user2)
    end

    describe '.total_volunteers_by_spoken_language' do
      it 'returns the number of volunteers grouped by language name' do
        expect(described_class.total_volunteers_by_spoken_language)
          .to eql(lang1.name => 1, lang2.name => 4, lang3.name => 1)
      end
    end

    describe '.total_volunteer_hours_by_user' do
      it 'returns the volunteer hours grouped by user_id' do
        expect(described_class.total_volunteer_hours_by_user)
          .to eql(or_user.id  => 1.0,
                  wa_user1.id => 1.0,
                  wa_user2.id => 5.0,
                  wa_user3.id => 1.0)
      end
    end
  end

  describe '#at_least_one_age_range' do
    it 'at_least_one_age_range' do
      user = described_class.new

      user.at_least_one_age_range

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

  describe '#notifiable?' do
    it 'returns false if user does not have a phone' do
      user.phone = nil

      result = user.notifiable?

      expect(result).to be false
    end

    it 'returns true if user has a phone' do
      result = user.notifiable?

      expect(result).to be true
    end
  end

  describe '#volunteerable?' do
    it 'volunteerable?' do
      user   = described_class.new
      result = user.volunteerable?

      expect(result).to be false
    end
  end

  describe '.notifiable' do # scope test
    it 'supports named scope notifiable' do
      result = described_class.notifiable

      expect(result).to all(be_a(described_class))
    end
  end

  describe '.shifts_by_user' do
    it 'shifts_by_user' do
      result = described_class.shifts_by_user

      expect(result).to be_empty
    end
  end

  describe '.volunteerable_by_language' do
    it 'volunteerable_by_language' do
      result = described_class.volunteerable_by_language

      expect(result).to be_empty
    end
  end

  describe '#to_s' do
    before do
      user.first_name = 'Santa'
      user.last_name  = 'Claus'
    end

    it 'to_s' do
      result = user.to_s

      expect(result).to eql('Santa Claus')
    end
  end

  describe '#role_display' do
    it 'returns a string' do
      expect(user.role_display).to be_a_kind_of(String)
    end

    it 'return the correct string' do
      user.role = 'social_worker'
      expect(user.role_display).to eq('Child Welfare Worker')
    end

    context 'when the translation is not found' do
      it 'return the titleize titleized' do
        user.role = 'this_role_does_not_exist'
        expect(user.role_display).to eq('This Role Does Not Exist')
      end
    end
  end

  describe 'before_save :check_phone_verification' do
    let(:user) { create(:user, verified: true) }

    it 'unverifies a user when their phone number changes' do
      expect(user.verified?).to be true
      user.save!
      expect(user.verified?).to be true
      user.phone = '4155551212'
      user.save!
      expect(user.verified?).to be false
    end
  end

  describe '#e164_phone' do
    it 'returns phone number in E.164 format' do
      expect(user.phone).to eq('(360) 610-7089')
      expect(user.e164_phone).to eq('+13606107089')
    end
  end

  describe '#office_notification_ids' do
    let!(:office2) { create(:office) }
    let!(:office_user2) do
      create(:office_user, user: user, office: office2, send_notifications: true)
    end

    it 'returns office ids where office_user has send_notifications set to true' do
      expect(user.office_notification_ids).to eq([office2.id])
    end
  end

  describe '#office_notification_ids=' do
    let(:office2) { create(:office) }
    let(:office_user1) { user.office_users.first }
    let!(:office_user2) { create(:office_user, user: user, office: office2) }

    it 'sets send_notifications to true for office_users with passed office ids' do
      expect(office_user1.send_notifications?).to be false
      expect(office_user2.send_notifications?).to be false
      user.office_notification_ids = [office2.id.to_s]
      expect(office_user1.reload.send_notifications?).to be false
      expect(office_user2.reload.send_notifications?).to be true
    end
  end
end
