require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build :user }
  it 'has a valid factory' do
    expect(user.valid?).to be(true)
  end

  describe '{role}?' do
    it 'does something' do
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
end
