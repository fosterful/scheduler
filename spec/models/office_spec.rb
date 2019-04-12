# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Office, type: :model do
  let(:office) { build :office }

  it 'has a valid factory' do
    expect(office.valid?).to be(true)
  end

  # TODO: auto-generated
  describe '#notifiable_users' do
    it 'notifiable_users' do
      office = described_class.new
      result = office.notifiable_users

      expect(result).not_to be_nil
    end
  end

end
