require 'rails_helper'

RSpec.describe BlockOut, type: :model do
  let(:block_out) { build :block_out }

  it 'has a valid factory' do
    expect(block_out.valid?).to be(true)
  end
end
