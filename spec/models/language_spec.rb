require 'rails_helper'

RSpec.describe Language, type: :model do
  let(:language) { build :language }

  it 'has a valid factory' do
    expect(language.valid?).to be(true)
  end
end
