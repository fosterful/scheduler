# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:admin) { create(:admin) }

  describe '#create' do
    it 'POST create' do
      post :create

      expect(response).to have_http_status(:redirect)
    end
  end

  describe '#index' do
    let(:users) do
      create(:user, first_name: 'Aaron', last_name: 'Zippy')
      create(:user, first_name: 'Adam', last_name: 'Zappy')
    end

    before do
      sign_in admin
    end

    it 'GET index' do
      get :index

      expect(response).to have_http_status(:ok)
    end

    it 'orders by name asc' do
      users

      get :index, params: { users: { order: :name, direction: :asc } }

      expect(response).to have_http_status(:ok)
    end

    it 'orders by name desc' do
      users

      get :index, params: { users: { order: :name, direction: :desc } }

      expect(response).to have_http_status(:ok)
    end
  end

end
