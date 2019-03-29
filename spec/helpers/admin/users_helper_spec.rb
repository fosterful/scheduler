# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersHelper, type: :helper do

  describe '#filtered_attributes' do
    let(:page) { double }
    let(:attributes) { [email, duration] }
    let(:email) { double }
    let(:duration) { double }

    before do
      allow(page).to receive(:attributes).and_return(attributes)
      allow(email).to receive(:attribute).and_return(:email)
      allow(duration).to receive(:attribute).and_return(:duration)
    end

    it 'works' do
      result = helper.filtered_attributes(page)

      expect(result).to eql([email])
    end
  end

end
