# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AgeRange, type: :model do
  let(:age_range) { build :age_range }

  it 'has a valid factory' do
    expect(age_range.valid?).to be(true)
  end

  describe 'validation' do
    context 'when min is equal to max' do
      it 'record is valid' do
        expect(age_range.valid?).to be(true)
      end
    end

    context 'when min is less than max' do
      let(:age_range) { build :age_range, min: 1, max: 2 }

      it 'record is valid' do
        expect(age_range.valid?).to be(true)
      end
    end

    context 'when min is greater than max' do
      let(:age_range) { build :age_range, min: 2, max: 1 }

      it 'record is not valid' do
        expect(age_range.valid?).to be(false)
      end
    end
  end

  describe '#to_s' do
    it 'to_s' do
      result = age_range.to_s

      expect(result).to eql('1-1')
    end
  end

end
