# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RaceDashboard do

  # TODO: auto-generated
  describe '#display_resource' do
    it 'display_resource' do
      race_dashboard = described_class.new
      race = double('race')
      result = race_dashboard.display_resource(race)

      expect(result).not_to be_nil
    end
  end

end
