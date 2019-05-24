# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::TextNotification do

  let(:object) { described_class.instance }
  let(:phone_numbers) { ['(555) 555-1212', '8881234567'] }
  let(:message) { 'Hello' }

  describe '#send_messages' do
    it 'call' do
      expect do
        object.send_messages(phone_numbers, message)
      end.to change(SendTextMessageWorker.jobs, :count).by(2)
    end
  end

end
