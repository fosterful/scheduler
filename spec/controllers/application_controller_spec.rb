# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      head :ok
    end
  end

  describe 'before_filter :enforce_verification' do
    subject { get :index }

    before { sign_in(user) }

    context 'when user is not verified' do
      let(:user) { create(:user, verified: false) }

      it { is_expected.to redirect_to(verify_path) }

      context 'when in a Devise controller' do
        before do
          allow(controller).to receive(:devise_controller?).and_return(true)
          allow(controller).to receive(:configure_permitted_parameters)
        end

        it { is_expected.not_to redirect_to(verify_path) }
      end
    end

    context 'when user is verified' do
      let(:user) { create(:user) }

      it { is_expected.not_to redirect_to(verify_path) }
    end
  end
end
