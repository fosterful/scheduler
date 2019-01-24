# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Office, type: :model do
  let(:office) { build :office }

  it 'has a valid factory' do
    expect(office.valid?).to be(true)
  end
end
