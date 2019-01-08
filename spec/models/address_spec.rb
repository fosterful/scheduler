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

  describe 'skip api validation option' do
    let(:office) { build :office }

    it 'creates record without geocoding' do
      address = Address.new(
        street: "800 K St NW",
        city: "Washington",
        state: "DC",
        postal_code: "20001",
        latitude: "38.90204",
        longitude: "-76.02284"
      )
      address.skip_api_validation!
      office.address = address
      office.save!
      expect(address.persisted?).to be(true)
    end
  end
end
