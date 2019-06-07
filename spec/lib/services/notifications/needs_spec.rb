# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::NeedNotifier do

  let(:need) { create(:need) }

  describe '#call' do
    context 'when a need was created' do
      it 'sends a create notification' do
        expect_any_instance_of(Services::Notifications::Needs::Create)
          .to receive(:call).once

        described_class.new(need, :create).call
      end
    end

    context 'when a need is updated' do
      it 'sends an update notification' do
        expect_any_instance_of(Services::Notifications::Needs::Update)
          .to receive(:call).once

        described_class.new(need, :update).call
      end
    end

    context 'when a need is destroyed' do
      it 'sends an destroy notification' do
        expect_any_instance_of(Services::Notifications::Needs::Destroy)
          .to receive(:call).once

        described_class.new(need, :destroy).call
      end
    end
  end


  # TODO: auto-generated
  describe '#phone_numbers' do
    it 'phone_numbers' do
      need = double('need')
      action = double('action')
      event_data = double('event_data')
      need_notifier = described_class.new(need, action, event_data)
      result = need_notifier.phone_numbers

      expect(result).not_to be_nil
    end
  end


end
