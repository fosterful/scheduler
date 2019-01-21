require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build :user }
  it 'has a valid factory' do
    expect(user.valid?).to be(true)
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
    let(:time) { { start_at: 1.day.from_now, end_at: 1.day.from_now + 1.hour } }
    subject { User.available_within(*time.values) }

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
end
