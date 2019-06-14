# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OfficeDashboard do
  let(:object) { described_class.new }
  let(:office) { create(:wa_office) }

  describe '#display_resource' do
    it 'display_resource' do
      result = object.display_resource(office)
      expect(result).to eql('Vancouver Office | WA | Region: 1')
    end
  end

end
