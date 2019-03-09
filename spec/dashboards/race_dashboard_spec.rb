# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RaceDashboard do
  let(:object) { described_class.new }

  describe '#display_resource' do
    let(:race) { build(:race) }

    it 'display_resource' do
      result = object.display_resource(race)

      expect(result).to eql('Hispanic')
    end
  end

end
