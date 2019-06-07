# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Shifts::Message::Destroy do

  let(:object) { described_class.call(shift, event_data) }
  let(:event_data) { {} }
  let(:shift) { create(:shift, start_at: starts) }
  let(:starts) { Time.parse('2019-05-23 11:10:15 PDT -07:00') }
  let(:destroy_message) do
    "The shift from 11:10am to 12:10pm has been removed from a need at your "\
      "local office. http://localhost:3000/needs"
  end

  describe '#call' do
    it 'returns expected string' do
      expect(object).to eql(destroy_message)
    end
  end
end
