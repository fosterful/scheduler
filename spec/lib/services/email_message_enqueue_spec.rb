# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::EmailMessageEnqueue do
  let(:email) { 'admin@example.com' }
  let(:message) { "It's a message." }

  describe '.send_messages' do
    it 'send_messages' do
      expect(UserMailer).to receive(:with).with(email: email, message: message).and_call_original
      described_class.send_messages([email], message)
    end
  end

end