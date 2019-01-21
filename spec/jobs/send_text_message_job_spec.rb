require 'rails_helper'

RSpec.describe SendTextMessageJob, type: :job do
  describe '#perform_later' do
    subject { described_class.perform_later('123-456-7890', 'Hello World') }
    it 'logs a message' do
      expect { subject }.to have_enqueued_job(described_class).with('123-456-7890', 'Hello World')
    end
  end

  describe '#perform' do
    subject { described_class.new.perform('123-456-7890', 'Hello World') }
    it 'logs a message' do
      expect(Rails).to receive_message_chain(:logger, :info).with("Sending text to 123-456-7890: Hello World")
      subject
    end
  end
end
