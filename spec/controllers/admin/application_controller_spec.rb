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
    let(:params) do
      ActionController::Parameters
        .new(need: { age_range_ids: [], duration: 20 })
    end

    it 'resource_params' do
      allow_any_instance_of(described_class)
        .to receive(:params).and_return(params)
      expect(object).to receive(:resource_class).and_return(need)

      result = object.resource_params

      expect(result.keys).to match_array(%w(age_range_ids))
    end
  end
end
