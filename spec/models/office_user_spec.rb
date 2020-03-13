# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OfficeUser, type: :model do
  let(:office_user) { build(:office_user) }

  it 'has a valid factory' do
    expect(office_user.valid?).to be(true)
  end

  context 'scopes' do
    context '#notifiable' do
      it 'excludes users who are deactivated' do
        office_user = build(:office_user, send_notifications: true)
        user = build(:user, deactivated: true)
        expect(OfficeUser.notifiable).to_not include user
      end
    end
  end
end
