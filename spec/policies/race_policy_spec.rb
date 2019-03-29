# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RacePolicy do
  subject { described_class.new(user, record) }

  let(:record) { build(:race) }
  let(:user)   { build(:user) }

  describe '#permitted_attributes' do
    it 'permitted_attributes' do
      result = subject.permitted_attributes

      expect(result).to eql(%i(name))
    end
  end

end
