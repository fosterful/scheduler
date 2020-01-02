# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'New need form', type: :system, js: true do
  let!(:coordinator) { create(:coordinator) }
  let!(:office1) { Office.first }
  let!(:office2) { create(:office) }
  let!(:social_worker1) do
    create(:social_worker, offices: [office1], first_name: 'Social Worker 1')
  end
  let!(:social_worker2) do
    create(:social_worker, offices: [office2], first_name: 'Social Worker 2')
  end

  before { sign_in coordinator }

  describe 'social worker selection' do
    it 'pre-populates social workers for first office' do
      visit new_need_path
      expect(page).to have_text(social_worker1.first_name)
      expect(page).not_to have_text(social_worker2.first_name)
    end

    it 'changes the list of social workers upon selecting an office' do
      visit new_need_path
      select office2.name, from: 'Office'
      expect(page).not_to have_text(social_worker1.first_name)
      expect(page).to have_text(social_worker2.first_name)
    end
  end
end
