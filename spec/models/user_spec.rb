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
end
