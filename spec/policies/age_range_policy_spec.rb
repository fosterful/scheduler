# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AgeRangePolicy do
  let(:subject) { described_class.new(user, record) }

  let(:user) { build(:user) }
  let(:record) { build(:need) }

  describe '#permitted_attributes' do
    it 'permitted_attributes' do
      result = subject.permitted_attributes

      expect(result).to match_array(%i(min max))
    end
  end

end
