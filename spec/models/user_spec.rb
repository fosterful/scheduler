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

  # TODO: auto-generated
  describe '.notifiable' do # scope test
    it 'supports named scope notifiable' do
      expect(described_class.limit(3).notifiable).to all(be_a(described_class))
    end
  end

  # TODO: auto-generated
  describe '.with_phone' do # scope test
    it 'supports named scope with_phone' do
      expect(described_class.limit(3).with_phone).to all(be_a(described_class))
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

  # TODO: auto-generated
  describe '#volunteerable?' do
    it 'volunteerable?' do
      user = described_class.new
      result = user.volunteerable?

      expect(result).not_to be_nil
    end
  end

end
