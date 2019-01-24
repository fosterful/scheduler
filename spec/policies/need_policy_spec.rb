# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NeedPolicy do
  let(:creator) { build :user, role: 'social_worker' }
  let(:record) { create :need, user: creator }

  subject { described_class.new(user, record) }

  context 'for volunteers' do
    let(:user) { create :user, role: 'volunteer' }

    context 'of the office' do
      before { record.office.users << user }

      it { is_expected.to permit_action(:index) }
      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_action(:new) }
      it { is_expected.to forbid_action(:create) }
      it { is_expected.to forbid_action(:edit) }
      it { is_expected.to forbid_action(:update) }
      it { is_expected.to forbid_action(:destroy) }

      describe '.scope' do
        it 'scopes the query' do
          expect(described_class::Scope.new(user.reload, Need.all).resolve).to include(record)
        end
      end
    end

    context 'not of the office' do
      it { is_expected.to permit_action(:index) }
      it { is_expected.to forbid_action(:show) }

      describe '.scope' do
        it 'scopes the query' do
          expect(described_class::Scope.new(user.reload, Need.all).resolve).not_to include(record)
        end
      end
    end
  end

  context 'for social workers' do
    let(:user) { create :user, role: 'social_worker' }
    before { record.office.users << user }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }

    describe '.scope' do
      it 'scopes the query' do
        expect(described_class::Scope.new(user.reload, Need.all).resolve).to include(record)
      end
    end
  end

  context 'for admins' do
    let(:user) { create(:user, role: 'admin') }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }

    describe '.scope' do
      it 'scopes the query' do
        expect(described_class::Scope.new(user.reload, Need.all).resolve).to match_array Need.all
      end
    end
  end
end
