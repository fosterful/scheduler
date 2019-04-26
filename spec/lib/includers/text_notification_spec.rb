# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TextNotification do

  let(:object) { OpenStruct.new(params).extend(described_class) }
  let(:params) { { phone_numbers: phone_numbers, message: message } }
  let(:phone_numbers) { ['(555) 555-1212', '8881234567'] }
  let(:message) { 'Hello' }

  describe '#send_messages' do
    it 'call' do
      expect_any_instance_of(Services::TextMessageEnqueue)
        .to receive(:call).once.and_call_original

      object.send_messages
    end
  end

end
