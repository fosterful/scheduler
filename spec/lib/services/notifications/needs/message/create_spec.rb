# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Needs::Message::Create do
  describe '#message' do
    let(:object) { described_class.new(need) }
    let(:need) { create(:need, start_at: starts) }
    let(:starts) { Time.zone.now.tomorrow.change(hour: 12, minute: 0) }
    let(:url) { "http://localhost:3000/needs/#{need.id}" }

    it 'returns expected message for create event' do
      result = object.message

      expect(result)
        .to eql("Your help is needed at the child welfare office (in #{need.office.name}). Click here to respond yes/no: #{url}")
    end
  end
end
