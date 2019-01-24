# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Needs", type: :request do
  let(:need) { create :need }
  before { sign_in need.user }

  describe '#index' do
    it 'is successful' do
      get needs_path
      expect(response).to be_successful
    end
  end

  describe '#show' do
    it 'is successful' do
      get need_path(need)
      expect(response).to be_successful
    end
  end

  describe '#new' do
    it 'is successful' do
      get new_need_path
      expect(response).to be_successful
    end
  end

  describe '#create' do
    it 'is redirects to the need' do
      expect(Services::BuildNeedShifts).to receive(:call).and_return([])
      expect(Services::SendNeedNotifications).to receive(:call)
      post needs_path, params: { need: attributes_for(:need).merge(office_id: need.office_id) }
      expect(response).to redirect_to(assigns(:need))
    end
  end

  describe '#edit' do
    it 'is successful' do
      get edit_need_path(need)
      expect(response).to be_successful
    end
  end

  describe '#update' do
    it 'is redirects to the need' do
      expect(Services::SendNeedNotifications).to receive(:call)
      put need_path(need), params: { need: { number_of_children: 20 } }
      expect(response).to redirect_to(assigns(:need))
    end
  end

  describe '#edit' do
    it 'is successful' do
      delete need_path(need)
      expect(response).to redirect_to(needs_path)
    end
  end
end