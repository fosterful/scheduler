require 'rails_helper'

RSpec.describe NeedPolicy do
  let(:creator) { build :user, role: 'social_worker' }
  let(:record) { build :need, user: creator }

  subject { described_class.new(user, record) }

  context 'for volunteers' do
    let(:user) { build :user, role: 'volunteer' }

    context 'of the office' do
      before { record.office.users << user }

      it { is_expected.to permit_action(:index) }
      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_action(:new) }
      it { is_expected.to forbid_action(:create) }
      it { is_expected.to forbid_action(:edit) }
      it { is_expected.to forbid_action(:update) }
      it { is_expected.to forbid_action(:destroy) }
    end

    context 'not of the office' do
      it { is_expected.to permit_action(:index) }
      it { is_expected.to forbid_action(:show) }
    end
  end

  context 'for social workers' do
    let(:user) { build :user, role: 'social_worker' }
    before { record.office.users << user }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end
end
