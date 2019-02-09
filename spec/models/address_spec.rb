# frozen_string_literal: true

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

  describe '#validate_and_geocode' do
    context 'address is valid' do
      it 'is valid and geocded' do
        expect(address.save).to be(true)
        expect(address.latitude).not_to be(nil)
      end
    end

    context 'address is not valid' do
      it 'is not valid and geocded' do
        allow_any_instance_of(MainStreet::AddressVerifier).to receive(:success?).and_return(false)
        expect(address.save).to be(false)
        expect(address.errors.any?).to eq(true)
      end
    end

    context 'skip validation' do
      it 'creates record without geocoding' do
        address.skip_api_validation!
        address.save!
        expect(address.latitude).to be(nil)
      end
    end
  end
end