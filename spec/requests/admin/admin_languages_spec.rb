# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin languages spec', type: :request do
  before { sign_in create :user }

  it 'does not allow unauthorized access' do
    get admin_languages_path

    expect(response).to redirect_to(:root)
  end

  describe '#create' do
    before { sign_in create :user, role: 'admin' }

    it 'redirects to show view after creating the language' do
      post admin_languages_path, params: { language: { name: 'foo' } }

      expect(response).to redirect_to(admin_language_path(Language.last))
    end

    it 'renders errors if present (missing name)' do
      post admin_languages_path, params: { language: { name: '' } }

      expect(response.body).to include('error')
    end
  end

  describe 'show' do
    before { sign_in create :user, role: 'admin' }

    let(:language) { create :language, name: 'Spanish' }

    it 'displays the language' do
      get admin_language_path(language)

      expect(response.body).to include('Spanish')
    end
  end
end
