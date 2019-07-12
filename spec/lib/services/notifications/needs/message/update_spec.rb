# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Needs::Message::Update do
  describe '#message' do
    let(:object) { described_class.new(need) }
    let(:need) { create(:need, start_at: starts) }
    let(:starts) { Time.zone.now.tomorrow.change(hour: 12, minute: 0) }
    let(:day_str) { starts.to_s(:month_day) }
    let(:time_str) { starts.strftime('%I:%M%P') }
    let(:url) {  "http://localhost:3000/needs/#{need.id}" }

    it 'returns expected message for update event' do
      result = object.message

      expect(result)
        .to eql("A new need starting #{day_str} at #{time_str} has opened "\
                "up at your local office! #{url}")
    end
  end
end
