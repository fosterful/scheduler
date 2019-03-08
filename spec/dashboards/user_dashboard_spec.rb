# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserDashboard do
  let(:object) { described_class.new }
  let(:user) { build(:user) }

  describe '#display_resource' do
    it 'display_resource' do
      result = object.display_resource(user)

      expect(result).to eql('Test User')
    end
  end


end
