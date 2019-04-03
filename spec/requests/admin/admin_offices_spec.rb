# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin offices spec', type: :request do
  before { sign_in create :user }

  it 'does not allow unauthorized access' do
    get admin_offices_path
    expect(response).to redirect_to(:root)
  end

  describe '#create' do
    before { sign_in create :user, role: 'admin' }

    it 'redirects to show view after creating the office' do
      post admin_offices_path, params: { office: { name: 'foo@example.com', address_attributes: { street: '1901 Main St', city: 'Vancouver', state: 'WA', postal_code: '98660' } } }
      expect(response).to redirect_to(admin_office_path(Office.last))
    end

    it 'renders errors if present (missing address)' do
      post admin_offices_path, params: { office: { name: 'foo' } }
      expect(response.body).to include('error')
    end

    describe 'skip_confirmation' do
      it 'off — renders error when geocode lookup fails on invalid address' do
        without_stub_request(SMARTYSTREETS_STUB) do
          post admin_offices_path, params: { office: { name: 'foo@example.com', address_attributes: { street: 'aaaaaaaaaaaa', city: 'aaaaaaaaa', state: 'AA', postal_code: '00000' }, skip_confirmation: '0' } }
          expect(response.body).to include('error')
        end
      end

      it 'on — redirects to show view creating the office on invalid address' do
        without_stub_request(SMARTYSTREETS_STUB) do
          post admin_offices_path, params: { office: { name: 'foo@example.com', address_attributes: { street: 'aaaaaaaaaaaa', city: 'aaaaaaaaa', state: 'AA', postal_code: '00000' }, skip_confirmation: '1' } }
          expect(response).to redirect_to(admin_office_path(Office.last))
        end
      end
    end
  end
end
