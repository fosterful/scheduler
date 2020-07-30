# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DashboardPolicy do
  subject { described_class.new(user) }

  context 'when for admins' do
    let(:user) { build :user, role: 'admin' }

    it { is_expected.to permit_action(:reports) }
    it { is_expected.to permit_action(:users) }
  end

  context 'when for coordinators' do
    let(:user) { build :user, role: 'coordinator' }

    it { is_expected.to permit_action(:reports) }
    it { is_expected.to permit_action(:users) }
  end

  context 'when for volunteers' do
    let(:user) { build :user, role: 'volunteer' }

    it { is_expected.not_to permit_action(:reports) }
    it { is_expected.not_to permit_action(:users) }
  end

  context 'when for social workers' do
    let(:user) { build :user, role: 'social_worker' }

    it { is_expected.to permit_action(:reports) }
    it { is_expected.not_to permit_action(:users) }
  end
end
