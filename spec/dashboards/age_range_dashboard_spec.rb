# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AgeRangeDashboard do

  let(:object) { described_class.new }

  describe '#display_resource' do
    it 'display_resource' do
      result = object.display_resource([6, 9])

      expect(result).to eql('6 to 9')
    end
  end

end
