# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do
  let(:user) { create(:user) }

  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  describe '#new' do
    it 'GET new' do

      get :new, format: :html

      expect(response).to have_http_status(:found)
    end
  end

  describe '#create' do
    it 'POST create' do
      post :create, params: { invite: {} }

      expect(response).to have_http_status(:found)
    end
  end

end
