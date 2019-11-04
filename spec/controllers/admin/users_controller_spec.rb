# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do

  describe '#create' do
    it 'POST create' do
      post :create

      expect(response).to have_http_status(:redirect)
    end
  end

  describe '#index' do
    it 'GET index' do
      get :index

      expect(response).to have_http_status(:found)
    end

    it 'orders by name' do
    #  needs content 
    end
  end

end
