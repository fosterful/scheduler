require 'rails_helper'

RSpec.describe AgeRange, type: :model do
  let(:age_range) { build :age_range }

  it 'has a valid factory' do
    expect(age_range.valid?).to be(true)
  end
end
