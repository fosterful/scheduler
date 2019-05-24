# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendTextMessageWorker do
  describe '#perform_async' do
    subject { described_class.perform_async('360-610-7089', 'Hello World') }

    it 'enqueues the worker' do
      expect { subject }.to change(described_class.jobs, :size).by(1)
    end
  end

  describe '#perform' do
    it 'calls to twilio api' do
      expect($twilio).to receive_message_chain(:api, :account, :messages, :create)
      described_class.new.perform('360-610-7089', 'Hello World')
    end

    context 'when the number is missing' do
      it 'does not call the twilio api' do
        allow($twilio).to receive(:api)
        described_class.new.perform(nil, 'Hello World')
        expect($twilio).not_to have_received(:api)
      end
    end

    context 'when the number is missing' do
      it 'does not call the twilio api' do
        allow($twilio).to receive(:api)
        described_class.new.perform('123-456-7890', 'Hello World')
        expect($twilio).not_to have_received(:api)
      end
    end
  end
end
