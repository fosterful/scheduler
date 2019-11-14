# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Responses', type: :system, js: true do
  let(:unavailable_user) { create(:user, first_name: 'Unavailable') }
  let(:pending_user) { create(:user, first_name: 'Pending') }
  let(:need) {
    create(:need, notified_user_ids: [unavailable_user.id, pending_user.id])
  }

  before { sign_in need.user }
  before { need.update unavailable_user_ids: [unavailable_user.id] }

  describe 'response toggle' do
    it 'toggle the unavailable list' do
      visit need_path(need)
      expect(page).not_to have_text(unavailable_user.name)

      find('#toggle-unavailable-list').click()
      expect(page).to have_text(unavailable_user.name)
    end

    it 'toggle the pending list' do
      visit need_path(need)
      expect(page).not_to have_text(pending_user.name)

      find('#toggle-pending-list').click()
      expect(page).to have_text(pending_user.name)
    end
  end
end
