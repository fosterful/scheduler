# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Race, type: :model do
  let(:race) { build :race }
  it 'has a valid factory' do
    expect(race.valid?).to be(true)
  end
end
