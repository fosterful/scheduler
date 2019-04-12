# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::TextMessageEnqueue do
  let(:phone_numbers) { ['(555) 123-4567'] }
  let(:message) { "It's a message." }

  # TODO: auto-generated
  describe '#call' do
    it 'call' do
      result = described_class.call(phone_numbers, message)

      expect(result).not_to be_nil
    end
  end

end
