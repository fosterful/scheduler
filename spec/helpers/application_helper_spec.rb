require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#flash_classes' do
    it 'returns a Hash' do
      expect(helper.flash_classes).to be_a(Hash)
    end
  end

  describe '#sign_up_as_link_html' do
    it 'returns a string' do
      expect(helper.sign_up_as_link_html('user')).to be_a(String)      
    end
  end
end
