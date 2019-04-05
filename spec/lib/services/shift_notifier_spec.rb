# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::ShiftNotifier do

  # TODO: auto-generated
  describe '#call' do
    it 'call' do
      shift = double('shift')
      action = double('action')
      user_is = double('user_is')
      user_was = double('user_was')
      shift_notifier = described_class.new(shift, action, user_is, user_was)
      result = shift_notifier.call

      expect(result).not_to be_nil
    end
  end

end
