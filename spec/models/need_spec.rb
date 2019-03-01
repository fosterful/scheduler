# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Need, type: :model do
  let(:need) { build :need }

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
end
