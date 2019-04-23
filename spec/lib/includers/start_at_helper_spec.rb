# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StartAtHelper do
  let(:start_at) { Time.zone.parse('2019-04-19 08:23:04 -0700') }
  let(:shift) do
    create(:shift, start_at: start_at, duration: 120).extend(described_class)
  end

  describe '#starting_day' do
    it 'starting_day' do
      result = shift.starting_day

      expect(result).to eql('Fri, Apr 19')
    end

    it 'starting_day for today' do
      expect(shift).to receive(:start_at).and_return(Time.zone.now)

      result = shift.starting_day

      expect(result).to eql('Today')
    end
  end

  describe '#start_time' do
    it 'start_time' do
      result = shift.start_time

      expect(result).to eql('08:23am')
    end
  end

end
