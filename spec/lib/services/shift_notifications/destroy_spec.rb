# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::ShiftNotifications::Destroy do
  let(:user) { create(:user) }

  subject { described_class.call(shift, 'https://test.com') }

  context 'a user is assigned to the shift' do
    let(:shift) { create(:shift, user: user) }

    it 'notifies the user' do
      expect(subject).to include(user)
    end
  end

  context 'a user is not assigned to the shift' do
    let(:shift) { create(:shift) }
    it 'does not notify anyone' do
      expect(subject.blank?).to be true
    end
  end
end
