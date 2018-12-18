require 'rails_helper'

RSpec.describe MethodField do
  subject { described_class.new(nil, data, nil) }

  describe '#to_s' do
    let(:data) { 'foobar' }

    it 'returns data' do
      expect(subject.to_s).to eq(data)
    end
  end
end
