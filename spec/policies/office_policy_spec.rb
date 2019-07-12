# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OfficePolicy, type: :policy do

  subject { described_class.new(user, record) }

  let(:record) { build(:need) }
  let(:user) { build(:user) }

  describe '#permitted_attributes' do
    it 'permitted_attributes' do
      result = subject.permitted_attributes

      expect(result)
        .to match_array([:name,
                         :region,
                         { address_attributes: %i(street
                                                  street2
                                                  city
                                                  state
                                                  postal_code
                                                  skip_api_validation) }])
    end
  end

end
