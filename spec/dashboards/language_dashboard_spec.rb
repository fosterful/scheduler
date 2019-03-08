# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LanguageDashboard do

  # TODO: auto-generated
  describe '#display_resource' do
    it 'display_resource' do
      language_dashboard = described_class.new
      language = double('language')
      result = language_dashboard.display_resource(language)

      expect(result).not_to be_nil
    end
  end

end
