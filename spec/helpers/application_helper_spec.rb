# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#flash_classes' do
    it 'returns a Hash' do
      expect(helper.flash_classes).to be_a(Hash)
    end
  end

  describe '#invite_options_for_select' do
    it 'returns a string' do
      without_partial_double_verification do
        user = build(:user)
        admin = build(:admin)
        allow(helper).to receive(:policy).and_return(Pundit.policy(admin, user))
        expect(helper.invite_options_for_select).to be_a(Array)
      end
    end
  end

  describe '#offices_for_select' do
    it 'returns a string' do
      expect(helper.offices_for_select(build(:user))).to include(include('Vancouver Office | WA | Region: 1'))
    end
  end

  describe '#profile_attributes_required?' do
    it 'checks the users role' do
      user = build(:user)
      expect(profile_attributes_required?(user)).to be(true)
    end
  end
end
