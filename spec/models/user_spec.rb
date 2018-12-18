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
end
