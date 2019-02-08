# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendTextMessageWorker do
  describe '#perform_async' do
    subject { described_class.perform_async('123-456-7890', 'Hello World') }
    it 'enqueues the worker' do
      expect { subject }.to change(described_class.jobs, :size).by(1)
    end
  end
end
