# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ApplicationController, type: :controller do
  let(:object) { subject }
  let(:need) { create(:need) }

  controller do
    def index
      # noop
    end
  end

  describe '#authenticate_admin' do
    it 'authenticate_admin' do
      get :index

      expect(response).to redirect_to(root_path)
      expect(flash[:error]).to eql('Not authorized.')
    end
  end

  describe '#resource_params' do
    xit 'resource_params' do
      # TODO: spec this
    end
  end

end
