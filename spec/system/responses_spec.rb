# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Responses', type: :system, js: true do
  let(:optout_user) { create(:user, first_name: 'Optout') }
  let(:pending_user) { create(:user, first_name: 'Pending') }
  let(:need) {
    create(:need, notified_user_ids: [optout_user.id, pending_user.id])
  }

  before { sign_in need.user }
  before { create(:optout, user: optout_user, need: need) }

  describe 'response toggle' do
    it 'toggle the optouts list' do
      visit need_path(need)
      expect(page).not_to have_text(optout_user.name)

      find('#toggle-optouts-list').click()
      expect(page).to have_text(optout_user.name)
    end

    it 'toggle the pending list' do
      visit need_path(need)
      expect(page).not_to have_text(pending_user.name)

      find('#toggle-pending-list').click()
      expect(page).to have_text(pending_user.name)
    end
  end
end
