# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationPolicy, type: :policy do
  let(:user)   { build(:user) }
  let(:record) { build(:user) }

  subject { described_class.new(user, record) }

  it { is_expected.to forbid_action(:index) }
  it { is_expected.to forbid_action(:show) }
  it { is_expected.to forbid_action(:new) }
  it { is_expected.to forbid_action(:create) }
  it { is_expected.to forbid_action(:edit) }
  it { is_expected.to forbid_action(:update) }
  it { is_expected.to forbid_action(:destroy) }

  context 'for an admin user' do
    let(:user) { build(:user, role: 'admin') }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end

  describe ApplicationPolicy::Scope do
    subject { described_class.new(user, scope) }

    let(:user) { :user }
    let(:scope) { double.as_null_object }

    it 'returns scope' do
      expect(subject.scope).to eq(scope)
    end

    it 'returns user' do
      expect(subject.user).to eq(user)
    end

    it 'returns @solve when #resolve is called' do
      expect(subject.resolve).to eq(scope)
    end
  end
end