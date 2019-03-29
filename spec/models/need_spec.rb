# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Need, type: :model do
  let(:need) { build :need }
  let(:spanish) { Language.find_by!(name: 'Spanish') }

  it 'has a valid factory' do
    expect(need.valid?).to be(true)
  end

  describe '#effective_start_at' do
    it 'returns need start at if no shifts' do
      result = need.effective_start_at

      expect(result).to eql(need.start_at)
    end

    it 'returns need start at if no shifts are earlier' do
      need.shifts << build(:shift, start_at: need.start_at)

      result = need.effective_start_at

      expect(result).to eql(need.start_at)
    end

    it 'returns earliest shift start at if earlier than need start at' do
      starts = need.start_at.advance(hours: -1)
      need.shifts << build(:shift, start_at: starts)
      need.save!

      result = need.effective_start_at

      expect(result).to eql(starts)
    end
  end

  describe '.current' do # scope test
    it 'supports named scope current' do
      expect(described_class.limit(3).current).to all(be_a(described_class))
    end
  end

  describe '#preferred_language' do
    it 'preferred_language' do
      result = need.preferred_language

      expect(result).to be_an_instance_of(NullLanguage)
    end

    it 'preferred_language' do
      need.preferred_language = spanish

      result = need.preferred_language

      expect(result).to eql(spanish)
    end
  end

  describe '#end_at' do
    it 'end_at' do
      result = need.end_at

      expect(result).to be_within(5.seconds).of(Time.zone.now.advance(hours: 2))
    end
  end

  describe '#expired?' do
    it 'expired?' do
      result = need.expired?

      expect(result).to be false
    end

    it 'returns true if expired' do
      need.start_at = Time.zone.now.advance(hours: -3)

      result = need.expired?

      expect(result).to be true
    end
  end

end
