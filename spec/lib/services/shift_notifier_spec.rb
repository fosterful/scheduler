# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::ShiftNotifier do
  let(:action) { nil }
  let(:shift) { create(:shift) }
  let(:user_is) { nil }
  let(:user_was) { nil }

  let(:object) { described_class.new(shift, action, user_is, user_was) }

  describe '#call' do
    context 'for create' do
      let(:action) { :create }

      it 'makes correct call for create' do
        expect_any_instance_of(Services::Notifications::Shifts::Create)
          .to receive(:call).with(shift, :create, nil, nil)

        object.call
      end
    end

    context 'for update' do
      let(:action) { :update }

      it 'makes correct call for update' do
        expect_any_instance_of(Services::Notifications::Shifts::Create)
          .to receive(:call).with(shift, :update, nil, nil)

        object.call
      end
    end

    context 'destroy' do
      let(:action) { :destroy }

      it 'makes correct call for destroy' do
        expect_any_instance_of(Services::Notifications::Shifts::Create)
          .to receive(:call).with(shift, :destroy, nil, nil)

        result = object.call

        expect(result).not_to be_nil
      end
    end

    context 'for create' do
      it 'makes correct call for create' do
        result = object.call

        expect(result).not_to be_nil
      end
    end
  end

end
