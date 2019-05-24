# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::ShiftNotifier do
  let(:action) { nil }
  let(:shift) { create(:shift) }
  let(:current_user) { nil }
  let(:user_was) { nil }

  let(:object) do
    described_class.new(shift,
                        action,
                        current_user: current_user, user_was: user_was)
  end

  describe '#call' do
    context 'for create' do
      let(:action) { :create }

      it 'makes correct call for create' do
        expect_any_instance_of(Services::Notifications::Shifts::Create)
          .to receive(:call).once

        object.call
      end
    end

    context 'for update' do
      let(:action) { :update }
      let(:current_user) { build(:social_worker) }
      let(:user_was) { shift.user }

      it 'makes correct call for update' do
        expect_any_instance_of(Services::Notifications::Shifts::Update)
          .to receive(:call).once

        object.call
      end
    end

    context 'destroy' do
      let(:action) { :destroy }

      it 'makes correct call for destroy' do
        expect_any_instance_of(Services::Notifications::Shifts::Destroy)
          .to receive(:call).once

        object.call
      end
    end
  end
end
