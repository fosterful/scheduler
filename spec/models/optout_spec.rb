require 'rails_helper'

RSpec.describe Optout, type: :model do
  let(:user) { create(:user) }
  let(:need) { create(:need) }

  it 'should validate uniqueness of user and need' do
    create(:optout, user: user, need: need)
    expect {
      create(:optout, user: user, need: need)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
