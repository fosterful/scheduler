# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::TextMessageEnqueue do
  let(:phone) { '(555) 123-4567' }
  let(:message) { "It's a message." }

  describe '.send_messages' do
    it 'send_messages' do
      expect(SendTextMessageWorker).to receive(:perform_async).once.with(phone, message)

      described_class.send_messages([phone], message)
    end
  end

end
