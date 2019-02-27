# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendTextMessageWorker do
  describe '#perform_async' do
    subject { described_class.perform_async('123-456-7890', 'Hello World') }
    it 'enqueues the worker' do
      expect { subject }.to change(described_class.jobs, :size).by(1)
    end
  end

  describe '#perform' do
    it 'calls to twilio api' do
      expect($twilio).to receive_message_chain(:api, :account, :messages, :create)
      described_class.new.perform('123-456-7890', 'Hello World')
    end
  end
end
