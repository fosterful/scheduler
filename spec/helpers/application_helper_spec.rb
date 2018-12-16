require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#flash_classes' do
    it 'returns a Hash' do
      expect(helper.flash_classes).to be_a(Hash)
    end
  end

  describe '#invite_links' do
    it 'returns a string' do
      without_partial_double_verification do
        user = build(:user)
        allow(helper).to receive(:policy).and_return(Pundit.policy(user, user))
        expect(helper.invite_links).to be_a(String)
      end
    end
  end

  describe '#offices_for_select' do
    it 'returns a string' do
      expect(helper.offices_for_select(build :user)).to include(include("Vancouver Office | WA | Region: 1"))
    end
  end
end
