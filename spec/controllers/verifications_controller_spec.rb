require 'rails_helper'

RSpec.describe VerificationsController, type: :controller do
  let(:user) { create(:user, verified: false) }
  before { sign_in user }

  describe '#index' do
    it 'returns ok' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#send_code' do
    it 'calls twilio and redirects' do
      expect($twilio).to receive_message_chain(
        :verify, :services, :verifications, :create
      )
      post :send_code
      expect(flash[:notice]).to eq 'Verification code has been sent'
      expect(response).to redirect_to(verify_path)
    end
  end

  describe '#check_code' do
    subject { post :check_code, params: { code: '123456' } }
    before {
      expect($twilio).to receive_message_chain(
        :verify, :services, :verification_checks, :create
      ) { double(:check, status: status) }
    }

    context 'when code is approved' do
      let(:status) { 'approved' }

      it 'sets user as verified' do
        subject
        user.reload
        expect(user.verified?).to be true
        expect(flash[:notice]).to eq 'Phone number has been verified!'
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when code is not approved' do
      let(:status) { 'pending' }

      it 'does not verify user' do
        subject
        user.reload
        expect(user.verified).to be false
        expect(flash[:notice]).to eq 'Verification failed'
        expect(response).to redirect_to(verify_path)
      end
    end
  end
end
