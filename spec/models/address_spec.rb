require 'rails_helper'

RSpec.describe Address, type: :model do
  let(:address) { build :address }

  it 'has a valid factory' do
    expect(address.valid?).to be(true)
  end

  describe '#to_s' do
    it 'returns the full address as a string' do
      expect(address.to_s).to eq('1901 Main St Vancouver WA 98660')
    end
  end
end
