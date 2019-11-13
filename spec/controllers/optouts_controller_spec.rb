require 'rails_helper'

RSpec.describe OptoutsController, type: :controller do
  let(:need) { create(:need) }
  let(:user) { create(:user, role: 'volunteer') }

  before { sign_in user }
  before { need.office.users << user }

  describe 'POST create' do
    subject { post :create, params: { need_id: need } }

    it { is_expected.to redirect_to(need) }
  end
end
