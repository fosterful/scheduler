# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::TextNotification do

  # TODO: auto-generated
  describe '#call' do
    it 'call' do
      text_notification = described_class.new
      result = text_notification.call

      expect(result).not_to be_nil
    end
  end

end
