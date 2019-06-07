# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Shifts::Recipients::Destroy do

  let(:object) { described_class.new(shift, event_data) }
  let(:event_data) { {} }
  let(:shift) { create(:shift) }

  describe '#recipients' do
    it 'works' do
      expect(object.results).to be_an_instance_of(Array)
    end
  end

end
