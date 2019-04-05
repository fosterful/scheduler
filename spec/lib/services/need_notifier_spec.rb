# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::NeedNotifier do

  let(:need) { create(:need) }

  describe '#call' do
    it 'sends a create notification' do
      need_notifier = described_class.new(need, :create)

      expect_any_instance_of(Services::NeedNotifications::Create)
        .to receive(:call).with(need).once

      need_notifier.call
    end
  end

end
