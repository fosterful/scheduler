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
      post admin_offices_path,
           params: { office: { name:               'foo@example.com',
                               address_attributes: { street:      '1901 Main St',
                                                     city:        'Vancouver',
                                                     state:       'WA',
                                                     postal_code: '98660' } } }

      expect(response).to redirect_to(admin_office_path(Office.last))
    end

    it 'renders errors if present (missing address attributes)' do
      post admin_offices_path, params: { office: { name: 'foo', address_attributes: {street: ''} } }

      expect(response.body).to include('error')
    end
  end

  describe '#new' do
    before { sign_in create :user, role: 'admin' }

    it 'is successful' do
      get new_admin_office_path

      expect(response).to be_successful
    end

    it 'has address fields' do
      get new_admin_office_path

      expect(response.body).to include('Street')
    end
  end
end
