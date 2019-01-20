require 'rails_helper'

RSpec.describe Shift, type: :model do
  let(:shift) { build :shift }

  it 'has a valid factory' do
    expect(shift.valid?).to be(true)
  end
end
