# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Something', type: :system, js: true do

  describe 'home page' do
    it 'does something' do
      visit '/'
      expect(page).to have_text('Log In')
    end
  end
end
