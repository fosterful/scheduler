# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationPolicy, type: :policy do
  subject { described_class.new(user, record) }

  let(:user)   { build(:user) }
  let(:record) { build(:need) }

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

  describe '#index?' do
    it 'index?' do
      result = subject.index?

      expect(result).to be false
    end
  end

  describe '#show?' do
    it 'show?' do
      result = subject.show?

      expect(result).to be false
    end
  end

  describe '#create?' do
    it 'create?' do
      result = subject.create?

      expect(result).to be false
    end
  end

  describe '#new?' do
    it 'new?' do
      result = subject.new?

      expect(result).to be false
    end
  end

  describe '#update?' do
    it 'update?' do
      result = subject.update?

      expect(result).to be false
    end
  end

  describe '#edit?' do
    it 'edit?' do
      result = subject.edit?

      expect(result).to be false
    end
  end

  describe '#destroy?' do
    it 'destroy?' do
      result = subject.destroy?

      expect(result).to be false
    end
  end

end
