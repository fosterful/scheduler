require 'rails_helper'

RSpec.describe OmdRrule do
  subject do 
    described_class.new('FREQ=DAILY',
                        dtstart: 1.day.from_now)
  end

  describe '#current_recurrence_times' do
    it 'should only include the next 15 days worth of recurrences' do
      expect(subject.current_recurrence_times.length).to eq(15)
    end
  end

  describe '#last_recurrence' do
    it 'should enforce an upper bound of three years' do
      expect(subject.last_recurrence.year).to eq(3.years.from_now.year)
    end
  end
end