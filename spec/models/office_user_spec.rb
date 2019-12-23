# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OfficeUser, type: :model do
  let(:office_user) { build(:office_user) }

  it 'has a valid factory' do
    expect(office_user.valid?).to be(true)
  end
end
