# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LanguageDashboard do
  let(:object) { described_class.new }

  describe '#display_resource' do

    let(:language) { build(:language) }

    it 'display_resource' do
      result = object.display_resource(language)

      expect(result).to eql('Spanish')
    end
  end

end
