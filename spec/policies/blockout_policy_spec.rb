# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BlockoutPolicy do
  let(:subject) { described_class.new(user, record) }

  let(:user) { build(:user) }
  let(:record) { build(:need) }

  describe '#create?' do
    it 'create?' do
      result = subject.create?

      expect(result).to be false
    end
  end

  describe '#destroy?' do
    it 'destroy?' do
      result = subject.destroy?

      expect(result).to be false
    end
  end

  describe '#update?' do
    it 'update?' do
      result = subject.update?

      expect(result).to be false
    end
  end

  describe '#permitted_attributes' do
    it 'permitted_attributes' do
      result = subject.permitted_attributes

      expect(result).to match_array([:start_at,
                                     :end_at,
                                     :rrule,
                                     :reason,
                                     exdate: []])
    end
  end

end
