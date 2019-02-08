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

    it 'fails' do
      get need_path('foobar')
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eql("Sorry, we couldn't find that need.")
    end
  end

  describe '#new' do
    it 'is successful' do
      get new_need_path
      expect(response).to be_successful
    end
  end

  describe '#create' do
    context 'success' do
      it 'is redirects to the need' do
        expect(Services::BuildNeedShifts).to receive(:call).and_return([])
        expect(Services::NeedNotifications::Create).to receive(:call).and_return(true)
        post needs_path, params: { need: attributes_for(:need).merge(office_id: need.office_id) }
        expect(response).to redirect_to(assigns(:need))
      end
    end

    context 'failure' do
      it 'renders the new view' do
        expect_any_instance_of(Need).to receive(:update).and_return(false)
        post needs_path, params: { need: attributes_for(:need).merge(office_id: need.office_id) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe '#edit' do
    it 'is successful' do
      get edit_need_path(need)
      expect(response).to be_successful
    end
  end

  describe '#update' do
    context 'success' do
      it 'redirects to the need' do
        expect(Services::NeedNotifications::Update).to receive(:call).and_return(true)
        put need_path(need), params: { need: { number_of_children: 20 } }
        expect(response).to redirect_to(assigns(:need))
      end
    end

    context 'failure' do
      it 'renders the edit view' do
        expect_any_instance_of(Need).to receive(:save).and_return(false)
        put need_path(need), params: { need: { number_of_children: 20 } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe '#destroy' do
    context 'success' do
      it 'redirects to the index view with success message' do
        expect(Services::NeedNotifications::Destroy).to receive(:call).and_return(true)
        delete need_path(need)
        expect(response).to redirect_to(needs_path)
        expect(flash[:success]).to eql('Need successfully deleted')
      end
    end

    context 'failure' do
      it 'redirects to the index view' do
        expect_any_instance_of(Need).to receive(:destroy).and_return(false)
        delete need_path(need)
        expect(response).to redirect_to(needs_path)
        expect(flash[:error]).to eql('Failed to delete Need')
      end
    end
  end
end