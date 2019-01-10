require 'rails_helper'
require 'support/rake_shared_context'

describe 'scheduler:update_block_outs' do
  include_context 'rake'

  context 'with an end to occurrence' do
    it "updates current_recurring BlockOuts over time" do
      travel_to Time.zone.parse("2019-01-09")

      block_out = create :block_out_with_occurrences,
                         start_at: Time.zone.parse("2019-01-09 09:00:00 -0800"),
                         end_at: Time.zone.parse("2019-01-09 10:00:00 -0800"),
                         rrule: "FREQ=DAILY;UNTIL=#{Time.zone.parse("2019-01-29")}"

      expect(block_out.occurrences.count).to eq(16)

      travel_to Time.zone.parse("2019-01-14")
      expect {subject.execute }.to change { block_out.occurrences.count }.to(15)

      travel_to Time.zone.parse("2019-01-21")
      expect { subject.execute }. to change { block_out.occurrences.count }.to(8)

      travel_to Time.zone.parse("2019-01-28")
      expect { subject.execute }. to change { block_out.occurrences.count }.to(1)

      travel_to Time.zone.parse("2019-01-29")
      expect { subject.execute }. to change { block_out.occurrences.count }.to(0)
    end
  end

  context 'scheduled in the future with no end in sight' do
    it "updates current_recurring BlockOuts over time" do
      travel_to Time.zone.parse("2019-01-09")

      block_out = create :block_out_with_occurrences,
                         start_at: Time.zone.parse("2019-01-14 09:00:00 -0800"),
                         end_at: Time.zone.parse("2019-01-14 10:00:00 -0800"),
                         rrule: 'FREQ=DAILY'

      expect(block_out.occurrences.count).to eq(11)

      travel_to Time.zone.parse("2019-01-14")
      expect { subject.execute }.to change { block_out.occurrences.count }.to(16)
        .and change { block_out.occurrences.reload.last.start_at.to_date }.to(Date.parse("2019-01-29"))

      travel_to Time.zone.parse("2019-01-31")
      expect { subject.execute }.not_to(change { block_out.occurrences.count })

      travel_to Time.zone.parse("2019-12-31")
      expect { subject.execute }.not_to(change { block_out.occurrences.count })

      # Max occurrence is 3 years
      travel_to block_out.last_occurrence + 1.day
      expect { subject.execute }.to change { block_out.occurrences.count }.to(0)
    end
  end
end

