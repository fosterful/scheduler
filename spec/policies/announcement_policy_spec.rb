# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnnouncementPolicy do
  subject { described_class.new(user, record) }

  let(:record) { build(:race) }
  let(:user) { build(:user) }
  let(:object) { subject }
  let(:admin) { build(:admin) }

  describe '#permitted_attributes' do
    it 'permitted_attributes' do
      result = object.permitted_attributes

      expect(result).to eql([:message, { user_ids: [] }])
    end
  end

  describe '#index?' do
    context 'as admin' do
      let(:user) { admin }

      it 'returns true' do
        result = object.index?

        expect(result).to be true
      end
    end

    context 'as non admin' do
      it 'returns false' do
        result = object.index?

        expect(result).to be false
      end
    end
  end

  describe '#show?' do
    context 'as admin' do
      let(:user) { admin }

      it 'returns true' do
        result = object.show?

        expect(result).to be true
      end
    end

    context 'as non admin' do
      it 'returns false' do
        result = object.show?

        expect(result).to be false
      end
    end
  end

  describe '#new?' do
    context 'as admin' do
      let(:user) { admin }

      it 'returns false' do
        result = object.new?

        expect(result).to be true
      end
    end

    context 'as non admin' do
      it 'returns false' do
        result = object.new?

        expect(result).to be false
      end
    end
  end

  describe '#create?' do
    context 'as admin' do
      let(:user) { admin }

      it 'returns false' do
        result = object.create?

        expect(result).to be true
      end
    end

    context 'as non admin' do
      it 'returns false' do
        result = object.create?

        expect(result).to be false
      end
    end
  end

  describe '#edit?' do
    context 'as admin' do
      let(:user) { admin }

      it 'returns false' do
        result = object.edit?

        expect(result).to be false
      end
    end

    context 'as non admin' do
      let(:user) { admin }

      it 'returns false' do
        result = object.edit?

        expect(result).to be false
      end
    end
  end

  describe '#update?' do
    context 'as admin' do
      let(:user) { admin }

      it 'returns false' do
        result = object.update?

        expect(result).to be false
      end
    end

    context 'as non admin' do
      it 'returns false' do
        result = object.update?

        expect(result).to be false
      end
    end
  end

  describe '#destroy?' do
    context 'as admin' do
      let(:user) { admin }

      it 'returns false' do
        result = object.destroy?

        expect(result).to be false
      end
    end

    context 'as non admin' do
      it 'returns false' do
        result = object.destroy?

        expect(result).to be false
      end
    end
  end
end
