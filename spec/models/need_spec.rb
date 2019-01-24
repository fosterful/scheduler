# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Need, type: :model do
  let(:need) { build :need }

  it 'has a valid factory' do
    expect(need.valid?).to be(true)
  end
end
