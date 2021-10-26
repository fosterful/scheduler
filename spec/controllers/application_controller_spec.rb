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

  describe 'before_filter :enforce_covid_19_vaccinated' do
    subject { get :index }

    before { sign_in(user) }

    context 'when user is not covid_19_vaccinated' do
      let(:user) { create(:user, covid_19_vaccinated: false) }

      it { is_expected.to redirect_to(vaccination_status_path) }

      context 'when in a Devise controller' do
        before do
          allow(controller).to receive(:devise_controller?).and_return(true)
          allow(controller).to receive(:configure_permitted_parameters)
        end

        it { is_expected.not_to redirect_to(vaccination_status_path) }
      end

      context 'when the user is not require_covid_19_vaccinated?' do
        let(:user) { create(:user, covid_19_vaccinated: false, offices: [build(:or_office)]) }
        
        it { is_expected.not_to redirect_to(vaccination_status_path) }
      end
    end

    context 'when user is covid_19_vaccinated' do
      let(:user) { create(:user) }

      it { is_expected.not_to redirect_to(vaccination_status_path) }
    end
  end

  describe '#need_creation_disabled?' do
    let(:controller) { described_class.new }

    subject { controller.need_creation_disabled? }

    context 'when need_creation_disabled is not set' do
      it 'is returns false' do
        expect(subject).to eq(false)
      end
    end

    context 'when need_creation_disabled is set' do
      before { controller.redis.set('need_creation_disabled', true) }
      after { controller.redis.del('need_creation_disabled') }

      it 'is returns true' do
        expect(subject).to eq(true)
      end
    end
  end
end
