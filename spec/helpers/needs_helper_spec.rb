# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NeedsHelper, type: :helper do

  describe '#race_options_for_select' do
    it 'works' do
      result = helper.race_options_for_select

      expect(result).to eql([['Hispanic', 1]])
    end
  end

end
