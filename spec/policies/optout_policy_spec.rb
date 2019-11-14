# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OptoutPolicy do
  subject { described_class.new(user, record) }

  let(:record) { create :optout, user: user, need: need }
  let(:user)   { build(:user) }
  let(:need)   { build(:need) }

  context 'when user is an admin' do
    let(:user) { create(:user, role: 'admin') }

    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:update) }
  end

  context 'when user is a volunteer' do
    let(:user) { create :user, role: 'volunteer' }

    context 'when in the office' do
      before { record.need.office.users << user }

      it { is_expected.to permit_action(:create) }
      it { is_expected.to permit_action(:update) }
    end

    context 'when not in the office' do
      it { is_expected.to forbid_action(:create) }
      it { is_expected.to forbid_action(:update) }
    end
  end
end
