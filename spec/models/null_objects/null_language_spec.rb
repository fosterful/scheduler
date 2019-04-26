# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NullLanguage, type: :model do

  let(:object) { described_class.new }

  describe '#name' do
    it 'returns a value' do
      expect(object.name).to eq('English')
    end
  end
end
