# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Needs::Message::Destroy do
  describe '#message' do
    let(:object) { described_class.new(need) }
    let(:need) { build(:need) }

    it 'returns expected message' do
      result = object.message

      expect(result).to eql("A need at #{need.office} has been deleted.")
    end
  end

end
