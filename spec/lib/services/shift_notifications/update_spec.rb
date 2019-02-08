# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::ShiftNotifications::Update do
  let(:coordinator) { create(:user, role: 'coordinator') }
  let(:shift) { create(:shift) }
  let(:volunteer) { create(:user) }
  let(:social_worker) { create(:user, role: 'social_worker') }

  context 'as a volunteer' do
    subject { described_class.call(shift, 'https://test.com', volunteer) }

    context 'assigns themself to a shift' do
      it 'notifies the social workers' do
        binding.pry
        expect(subject).to include(social_worker)
      end

      it 'notifies the need creator' do
        expect(subject).to include(coordinator)
      end
    end

    context 'unassigns themself from a shift' do
      it 'does a thing' do

      end
    end
  end


  context 'when a scheduler assigns a volunteer' do

  end

  context 'when a scheduler unassigns a volunteer' do

  end
end
