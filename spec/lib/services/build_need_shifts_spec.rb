# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::BuildNeedShifts do
  let(:need_start_at) { Time.zone.parse('2019-01-09 08:00:00 -0800') }
  let(:need) { build :need, start_at: need_start_at }
  subject { described_class.call(need) }

  it 'returns an array of shifts' do
    expect(subject).to include(a_kind_of(Shift))
  end

  context 'a need with an expected duration of 2 hours' do
    let(:need) { build :need, expected_duration: 120, start_at: need_start_at }

    it 'returns two shifts' do
      expect(subject.length).to eq(2)
    end

    it 'returns shifts that add up to the need duration' do
      expect(subject.pluck(:duration).inject(:+)).to eq(need.expected_duration)
    end

    it 'returns shifts which start every hour' do
      expect(subject.pluck(:start_at)).to include(
        Time.zone.parse('2019-01-09 08:00:00 -0800'),
        Time.zone.parse('2019-01-09 09:00:00 -0800')
      )
    end
  end

  context 'a need with an expected duration of 3.5 hours' do
    let(:need) { build :need, expected_duration: 210, start_at: need_start_at }

    it 'returns two shifts' do
      expect(subject.length).to eq(3)
    end

    it 'returns shifts that add up to the need duration' do
      expect(subject.pluck(:duration).inject(:+)).to eq(need.expected_duration)
    end

    it 'adds the remainder to the last shift' do
      expect(subject.last.duration).to eq(90)
    end

    it 'returns shifts which start every hour' do
      expect(subject.pluck(:start_at)).to include(
        Time.zone.parse('2019-01-09 08:00:00 -0800'),
        Time.zone.parse('2019-01-09 09:00:00 -0800'),
        Time.zone.parse('2019-01-09 10:00:00 -0800')
      )
    end
  end
end