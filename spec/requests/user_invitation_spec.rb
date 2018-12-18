require "rails_helper"

RSpec.describe "User invitations", type: :request do
  let(:user_attributes) { attributes_for(:user).slice(:email, :role).merge(office_ids: [office.id]) }
  let(:user) { create :user, role: 'coordinator' }
  let(:raw_invitation_token) { user.instance_variable_get(:@raw_invitation_token) }
  let(:office) { create :office }

  describe '#create' do
    before { sign_in user }

    it 'renders a 200 response after the invitation is sent' do
      user.offices << office
      post user_invitation_path, params: { user: user_attributes }
      expect(response).to redirect_to(:root)
    end

    it 'does not allow user to invite user to office they are not assigned to' do
      post user_invitation_path, params: { user: user_attributes }
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end
  end

  describe '#new' do
    before { sign_in user }
    it 'redirect to new user session if role is not defined' do
      get new_user_invitation_path
      expect(response).to redirect_to(root_path)
    end

    it 'redirect to new user session if role is not valid' do
      get new_user_invitation_path, params: { user: { role: 'admin' } }
      expect(response).to redirect_to(root_path)
    end

    it 'renders when role is valid' do
      get new_user_invitation_path, params: { user: { role: 'volunteer' } }
      expect(response).to be_successful
    end
  end

  describe '#edit' do
    let(:user) { User.invite!(user_attributes) }

    it 'renders with valid invitation token' do
      get accept_user_invitation_path(invitation_token: raw_invitation_token)
      expect(response).to be_successful
    end
  end

  describe '#update' do
    let(:user) { User.invite!(user_attributes) }

    context 'without required attributes' do
      it 'fails with an error' do
        put user_invitation_path, params: { user: { invitation_token: raw_invitation_token } }
        expect(response.body).to include('errors prohibited this user from being saved')
      end
    end

    context 'with required attributes' do
      let(:user_accept_attributes) do
        attributes_for(:user).slice(*User::PROFILE_ATTRS | %i[password password_confirmation])
                             .merge(invitation_token: raw_invitation_token)
      end

      it 'is successful' do
        put user_invitation_path, params: { user: user_accept_attributes }
        expect(response.body).not_to include('errors prohibited this user from being saved')
        expect(user.reload.first_name).not_to be(nil)
      end
    end
  end
end