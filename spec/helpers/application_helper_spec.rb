require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#flash_classes' do
    it 'returns a Hash' do
      expect(helper.flash_classes).to be_a(Hash)
    end
  end
end
