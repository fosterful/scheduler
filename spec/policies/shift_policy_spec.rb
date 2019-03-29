# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShiftPolicy do
  subject { described_class.new(user, record) }

  let(:user) { creator }
  let(:creator) { build :user, role: 'social_worker' }
  let(:record) { build :shift, user: creator }

  context 'for volunteers' do
    let(:user) { build :user, role: 'volunteer' }

    context 'of the office' do
      before { record.need.office.users << user }

      it { is_expected.to forbid_action(:create) }
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
    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end

  describe '.scope' do
    context 'for admins' do
      let!(:admin) { create(:user, role: 'admin') }

      before { create_list(:need_with_shifts, 2) }

      it 'contains all' do
        expect(described_class::Scope.new(admin, Shift).resolve).to contain_exactly(*Shift.all)
      end
    end

    context 'for non-admins' do
      let(:office1) { create(:office) }
      let(:office2) { create(:office) }
      let(:user) { create(:user) }

      before do
        create(:need_with_shifts, office: office1)
        create(:need_with_shifts, office: office2)
        user.offices << office1
      end

      it "contains only needs for the user's office" do
        expect(described_class::Scope.new(user, Shift).resolve).to contain_exactly(*Shift.joins(:need).where(needs: { office_id: office1.id }))
      end
    end
  end

  describe '#create?' do
    it 'create?' do
      result = subject.create?

      expect(result).to be false
    end
  end

  describe '#index?' do
    it 'index?' do
      result = subject.index?

      expect(result).to be false
    end
  end

  describe '#update?' do
    it 'update?' do
      result = subject.update?

      expect(result).to be true
    end
  end

  describe '#destroy?' do
    it 'destroy?' do
      result = subject.destroy?

      expect(result).to be false
    end
  end

  describe '#permitted_attributes_for_create' do
    it 'permitted_attributes_for_create' do
      result = subject.permitted_attributes_for_create

      expect(result).to match_array(%i(user_id start_at duration))
    end
  end

  describe '#permitted_attributes' do
    it 'permitted_attributes' do
      result = subject.permitted_attributes

      expect(result).to eql(%i(user_id))
    end
  end

end
