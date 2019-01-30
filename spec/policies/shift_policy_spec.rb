# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShiftPolicy do
  let(:creator) { build :user, role: 'social_worker' }
  let(:record) { build :shift, user: creator }

  subject { described_class.new(user, record) }

  context 'for volunteers' do
    let(:user) { build :user, role: 'volunteer' }

    context 'of the office' do
      before { record.need.office.users << user }

      it { is_expected.to forbid_action(:create) }
      it { is_expected.to forbid_action(:new) }
      it { is_expected.to forbid_action(:index) }
      it { is_expected.to forbid_action(:update) }
      it { is_expected.to forbid_action(:destroy) }

      context 'assigned as the shift user' do
        let(:record) { build :shift, user: user }
        it { is_expected.to permit_action(:update) }
      end

      context 'with no user assigned to shift' do
        let(:record) { build :shift, user: nil }
        it { is_expected.to permit_action(:update) }
      end
    end

    context 'not of the office' do
      it { is_expected.to forbid_action(:update) }
    end
  end

  context 'for social workers' do
    let(:user) { build :user, role: 'social_worker' }
    before { record.need.office.users << user }

    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end
end
